/*
 * Copyright Siemens AG, 2013-2015. Part of the SW360 Portal Project.
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License Version 2.0 as published by the
 * Free Software Foundation with classpath exception.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License version 2.0 for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program (please see the COPYING file); if not, write to the Free
 * Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */
package com.siemens.sw360.portal.portlets.admin;

import com.liferay.portal.kernel.portlet.PortletResponseUtil;
import com.siemens.sw360.datahandler.thrift.RequestStatus;
import com.siemens.sw360.datahandler.thrift.fossology.FossologyHostFingerPrint;
import com.siemens.sw360.datahandler.thrift.fossology.FossologyService;
import com.siemens.sw360.portal.common.PortalConstants;
import com.siemens.sw360.portal.common.UsedAsLiferayAction;
import com.siemens.sw360.portal.portlets.Sw360Portlet;
import org.apache.log4j.Logger;
import org.apache.thrift.TException;

import javax.portlet.*;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

public class FossologyAdminPortlet extends Sw360Portlet {

    private static final Logger log = Logger.getLogger(FossologyAdminPortlet.class);

    @Override
    public void doView(RenderRequest request, RenderResponse response) throws IOException, PortletException {
        List<FossologyHostFingerPrint> fingerPrints;

        try {
            FossologyService.Iface client = thriftClients.makeFossologyClient();
            fingerPrints = client.getFingerPrints();
            request.setAttribute(PortalConstants.FINGER_PRINTS, fingerPrints);
        } catch (TException e) {
            request.setAttribute(PortalConstants.FINGER_PRINTS, Collections.emptyList());
            log.error("Error retrieving fingerprints", e);
        }
        super.doView(request, response);
    }

    @UsedAsLiferayAction
    public void setFingerPrints(ActionRequest request, ActionResponse response) throws PortletException, IOException {
        List<FossologyHostFingerPrint> fingerPrints;
        FossologyService.Iface client;

        try {
            client = thriftClients.makeFossologyClient();
            fingerPrints = client.getFingerPrints();
        } catch (TException e) {
            log.error("Error retrieving fingerprints when setting", e);
            return;
        }
        for (FossologyHostFingerPrint fingerPrint : fingerPrints) {
            String bool = request.getParameter(fingerPrint.fingerPrint);
            fingerPrint.trusted = "on".equals(bool);
        }

        try {
            client.setFingerPrints(fingerPrints);
        } catch (TException e) {
            log.error("Problems setting finger prints", e);
        }
    }

    @Override
    public void serveResource(ResourceRequest request, ResourceResponse response) throws IOException, PortletException {
        String action = request.getParameter(PortalConstants.ACTION);
        if (PortalConstants.FOSSOLOGY_CHECK_CONNECTION.equals(action)) {
            serveCheckConnection(request, response);
        } else if (PortalConstants.FOSSOLOGY_DEPLOY_SCRIPTS.equals(action)) {
            serveDeployScripts(request, response);
        } else if (PortalConstants.FOSSOLOGY_GET_PUBKEY.equals(action)) {
            servePublicKeyFile(request, response);
        }
    }

    private void servePublicKeyFile(ResourceRequest request, ResourceResponse response) {
        try {
            String publicKey = thriftClients.makeFossologyClient().getPublicKey();

            final ByteArrayInputStream keyStream = new ByteArrayInputStream(publicKey.getBytes());
            PortletResponseUtil.sendFile(request, response, "sw360_id.pub", keyStream, "text/plain");
        } catch (IOException | TException e) {
            log.error("An error occurred while retrieving the public key", e);
        }
    }

    public void serveDeployScripts(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        RequestStatus deploy = RequestStatus.FAILURE;
        try {
            deploy = thriftClients.makeFossologyClient().deployScripts();
        } catch (TException e) {
            log.error("Error connecting to backend", e);
        }
        renderRequestStatus(request, response, deploy);
    }

    public void serveCheckConnection(ResourceRequest request, ResourceResponse response) throws PortletException, IOException {
        RequestStatus checkConnection = RequestStatus.FAILURE;
        try {
            checkConnection = thriftClients.makeFossologyClient().checkConnection();
        } catch (TException e) {
            log.error("Error connecting to backend", e);
        }
        renderRequestStatus(request, response, checkConnection);
    }

}