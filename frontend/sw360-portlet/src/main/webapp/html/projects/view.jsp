<%--
  ~ Copyright Siemens AG, 2013-2017. Part of the SW360 Portal Project.
  ~ With modifications by Bosch Software Innovations GmbH, 2016.
  ~
  ~ SPDX-License-Identifier: EPL-1.0
  ~
  ~ All rights reserved. This program and the accompanying materials
  ~ are made available under the terms of the Eclipse Public License v1.0
  ~ which accompanies this distribution, and is available at
  ~ http://www.eclipse.org/legal/epl-v10.html
  --%>

<%@include file="/html/init.jsp" %>
<%-- the following is needed by liferay to display error messages--%>
<%@include file="/html/utils/includes/errorKeyToMessage.jspf"%>
<%@ page import="com.liferay.portlet.PortletURLFactoryUtil" %>
<%@ page import="org.eclipse.sw360.datahandler.thrift.projects.Project" %>
<%@ page import="org.eclipse.sw360.portal.common.PortalConstants" %>
<%@ page import="javax.portlet.PortletRequest" %>

<portlet:defineObjects/>
<liferay-theme:defineObjects/>

<jsp:useBean id="projectList" type="java.util.List<org.eclipse.sw360.datahandler.thrift.projects.Project>"
             scope="request"/>

<jsp:useBean id="projectType" class="java.lang.String" scope="request"/>
<jsp:useBean id="projectResponsible" class="java.lang.String" scope="request"/>
<jsp:useBean id="releaseClearingStateSummary" class="org.eclipse.sw360.datahandler.thrift.components.ReleaseClearingStateSummary" scope="request"/>
<jsp:useBean id="businessUnit" class="java.lang.String" scope="request"/>
<jsp:useBean id="tag" class="java.lang.String" scope="request"/>
<jsp:useBean id="name" class="java.lang.String" scope="request"/>
<jsp:useBean id="state" class="java.lang.String" scope="request"/>

<core_rt:set var="stateAutoC" value='<%=PortalConstants.STATE%>'/>
<core_rt:set var="projectTypeAutoC" value='<%=PortalConstants.PROJECT_TYPE%>'/>

<portlet:resourceURL var="exportProjectsURL">
    <portlet:param name="<%=PortalConstants.ACTION%>" value="<%=PortalConstants.EXPORT_TO_EXCEL%>"/>
</portlet:resourceURL>

<portlet:resourceURL var="deleteAjaxURL">
    <portlet:param name="<%=PortalConstants.ACTION%>" value='<%=PortalConstants.REMOVE_PROJECT%>'/>
</portlet:resourceURL>

<portlet:renderURL var="impProjectURL">
    <portlet:param name="<%=PortalConstants.PAGENAME%>" value="<%=PortalConstants.PAGENAME_IMPORT%>"/>
</portlet:renderURL>

<portlet:renderURL var="addProjectURL">
    <portlet:param name="<%=PortalConstants.PAGENAME%>" value="<%=PortalConstants.PAGENAME_EDIT%>"/>
</portlet:renderURL>

<portlet:resourceURL var="projectReleasesAjaxURL">
    <portlet:param name="<%=PortalConstants.ACTION%>" value='<%=PortalConstants.FOSSOLOGY_GET_SENDABLE%>'/>
</portlet:resourceURL>


<portlet:resourceURL var="projectReleasesSendURL">
    <portlet:param name="<%=PortalConstants.ACTION%>" value='<%=PortalConstants.FOSSOLOGY_SEND%>'/>
</portlet:resourceURL>

<portlet:actionURL var="applyFiltersURL" name="applyFilters">
</portlet:actionURL>

<portlet:resourceURL var="loadClearingStateAjaxURL">
    <portlet:param name="<%=PortalConstants.ACTION%>" value='<%=PortalConstants.GET_CLEARING_STATE_SUMMARY%>'/>
</portlet:resourceURL>

<div id="header"></div>
<p class="pageHeader">
    <span class="pageHeaderBigSpan">Projects</span>
    <span class="pull-right">
        <input type="button" class="addButton" onclick="window.location.href='<%=addProjectURL%>'" value="Add Project" />
    </span>
</p>


<div id="searchInput" class="content1">
    <table>
        <thead>
        <tr>
            <th class="infoheading">
                Quick Filter
            </th>
        </tr>
        </thead>
        <tbody style="background-color: #f8f7f7; border: none;">
        <tr>
            <td>
                <input type="text" class="searchbar"
                       id="keywordsearchinput" value="" onkeyup="useSearch('keywordsearchinput')" />
            </td>
        </tr>
        </tbody>
    </table>
    <br/>
    <form action="<%=applyFiltersURL%>" method="post">
        <table>
            <thead>
            <tr>
                <th class="infoheading">
                    Advanced Search
                </th>
            </tr>
            </thead>
            <tbody style="background-color: #f8f7f7; border: none;">
            <tr>
                <td>
                    <label for="project_name">Project Name</label>
                    <input type="text" class="searchbar" name="<portlet:namespace/><%=Project._Fields.NAME%>"
                           value="${name}" id="project_name" class="filterInput">
                </td>
            </tr>
            <tr>
                <td>
                    <label for="project_version">Project Version</label>
                    <input type="text" class="searchbar" name="<portlet:namespace/><%=Project._Fields.VERSION%>"
                           value="${version}" id="project_version" class="filterInput">
                </td>
            </tr>
            <tr>
                <td>
                    <label for="project_type">Project Type</label>
                    <input type="text" class="searchbar" name="<portlet:namespace/><%=Project._Fields.PROJECT_TYPE%>"
                           value="${projectType}" id="project_type" class="filterInput">
                </td>
            </tr>
            <tr>
                <td>
                    <label for="project_responsible">Project Responsible (Email)</label>
                    <input type="text" class="searchbar" name="<portlet:namespace/><%=Project._Fields.PROJECT_RESPONSIBLE%>"
                           value="${projectResponsible}" id="project_responsible" class="filterInput">
                </td>
            </tr>
            <tr>
                <td>
                    <label for="group">Group</label>
                    <select class="searchbar toplabelledInput filterInput" id="group" name="<portlet:namespace/><%=Project._Fields.BUSINESS_UNIT%>">
                        <option value="" class="textlabel stackedLabel"
                                <core_rt:if test="${empty businessUnit}"> selected="selected"</core_rt:if>
                        ></option>
                        <core_rt:forEach items="${organizations}" var="org">
                            <option value="${org.name}" class="textlabel stackedLabel"
                                    <core_rt:if test="${org.name == businessUnit}"> selected="selected"</core_rt:if>
                            >${org.name}</option>
                        </core_rt:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="state">State</label>
                    <input type="text" class="searchbar" name="<portlet:namespace/><%=Project._Fields.STATE%>"
                           value="${state}" id="state" class="filterInput">
                </td>
            </tr>
            <tr>
                <td>
                    <label for="tag">Tag</label>
                    <input type="text" class="searchbar" name="<portlet:namespace/><%=Project._Fields.TAG%>"
                           value="${tag}" id="tag" class="filterInput">
                </td>
            </tr>

            </tbody>
        </table>
        <br/>
        <input type="submit" class="addButton" value="Search">
    </form>
</div>
<div id="projectsTableDiv" class="content2">
    <table id="projectsTable" cellpadding="0" cellspacing="0" border="0" class="display">
        <tfoot>
        <tr>
            <th colspan="6"></th>
        </tr>
        </tfoot>
    </table>
</div>
<div class="clear-float"></div>
<span class="pull-right">
        <select class="toplabelledInput formatSelect" id="extendedByReleases" name="extendedByReleases">
            <option value="false">Projects only</option>
            <option value="true">Projects with linked releases</option>
        </select>
        <input type="button" class="addButton" id="exportSpreadsheetButton" value="Export Spreadsheet" class="addButton" onclick="exportSpreadsheet()"/>
</span>


<div id="fossologyClearing" title="Fossology Clearing" style="display: none; background-color: #ffffff;">
    <form id="fossologyClearingForm" action="${projectReleasesSendURL}" method="post">
        <input id="projectId" name="<portlet:namespace/><%=PortalConstants.PROJECT_ID%>" hidden="" value=""/>

        <table id="fossologyClearingTable">
            <tbody>
            </tbody>
        </table>
        <input type="button" onclick="selectAll(this.parentNode)" value="Select all"/>
        <input type="button" onclick="closeOpenDialogs()" value="Close"/>
        <input type="submit" value="Send"/>
    </form>
</div>

<link rel="stylesheet" href="<%=request.getContextPath()%>/webjars/jquery-ui/1.12.1/jquery-ui.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/webjars/github-com-craftpip-jquery-confirm/3.0.1/jquery-confirm.min.css"><link rel="stylesheet" href="<%=request.getContextPath()%>/webjars/github-com-craftpip-jquery-confirm/3.0.1/jquery-confirm.min.css">
<script src="<%=request.getContextPath()%>/webjars/jquery/1.12.4/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/webjars/jquery-ui/1.12.1/jquery-ui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/webjars/datatables/1.10.7/js/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/webjars/github-com-craftpip-jquery-confirm/3.0.1/jquery-confirm.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/loadTags.js"></script>

<script>
    var projectsTable;

    var PortletURL;
    AUI().use('liferay-portlet-url', function (A) {
        PortletURL = Liferay.PortletURL;
        load();
        $('.filterInput').on('input', function () {
            $('#exportSpreadsheetButton').prop('disabled', true);
            <%--when filters are actually applied, page is refreshed and exportSpreadsheetButton enabled automatically--%>
        });
    });

    function useSearch(buttonId) {
        var val = $.fn.dataTable.util.escapeRegex($('#' + buttonId).val());
        projectsTable.columns(0).search(val, true).draw();
    }

    function makeProjectUrl(projectId, page) {
        var portletURL = PortletURL.createURL('<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.RENDER_PHASE) %>')
            .setParameter('<%=PortalConstants.PAGENAME%>', page)
            .setParameter('<%=PortalConstants.PROJECT_ID%>', projectId);
        return portletURL.toString();
    }

    function renderProjectActions(id, type, row) {
        <%--TODO most of this can be simplified to CSS properties --%>
        return "<img src='<%=request.getContextPath()%>/images/fossology-logo-24.gif'/" +
            " onclick='openSelectClearingDialog(\"" + id + "\", \"projectAction" + id + "\")' " +
            " alt='SelectClearing' title='send to Fossology'>" +
            "<span id='projectAction" + id + "'></span>"
            + renderLinkTo(
                makeProjectUrl(id, '<%=PortalConstants.PAGENAME_EDIT%>'),
                "",
                "<img src='<%=request.getContextPath()%>/images/edit.png' alt='Edit' title='Edit'>")
            + renderLinkTo(
                makeProjectUrl(id, '<%=PortalConstants.PAGENAME_DUPLICATE%>'),
                "",
                "<img src='<%=request.getContextPath()%>/images/ic_clone.png' alt='Duplicate' title='Duplicate'>")
            + "<img src='<%=request.getContextPath()%>/images/Trash.png'" +
            " onclick=\"deleteProject('" + id + "', '<b>" + replaceSingleQuote(row.name) + "</b>'," + replaceSingleQuote(row.linkedProjectsSize) + "," + replaceSingleQuote(row.linkedReleasesSize) + "," + replaceSingleQuote(row.attachmentsSize) + ")\" alt='Delete' title='Delete'/>";
    }

    function renderProjectNameLink(name, type, row) {
        return renderLinkTo(makeProjectUrl(row.id, '<%=PortalConstants.PAGENAME_DETAIL%>'), name);
    }

    function load() {
        prepareAutocompleteForMultipleHits('state', ${stateAutoC});
        prepareAutocompleteForMultipleHits('project_type', ${projectTypeAutoC});
        createProjectsTable();
        loadClearingStateSummaries();

    }
    function createProjectsTable() {
        var result = [];

        <core_rt:forEach items="${projectList}" var="project">
        result.push({
            "DT_RowId": "${project.id}",
            "id": '${project.id}',
            "name": '<sw360:ProjectName project="${project}"/>',
            "description": '<sw360:DisplayDescription description="${project.description}" maxChar="140" jsQuoting="'"/>',
            "state": ["<sw360:DisplayEnum value='${project.state}'/>", "<sw360:DisplayEnum value='${project.clearingState}'/>"],
            "clearing": 'Not loaded yet',
            "responsible": '<sw360:DisplayUserEmail email="${project.projectResponsible}" bare="true"/>',
            "linkedProjectsSize": '${project.linkedProjectsSize}',
            "linkedReleasesSize": '${project.releaseIdToUsageSize}',
            "attachmentsSize": '${project.attachmentsSize}'
        });
        </core_rt:forEach>

        projectsTable = $('#projectsTable').DataTable({
            "pagingType": "simple_numbers",
            "data": result,
            dom: "lrtip",
            search: {smart: false},
            "columns": [
                {title: "Project Name", data: "name", render: {display: renderProjectNameLink}},
                {title: "Description", data: "description"},
                {title: "Project Responsible", data: "responsible"},
                {title: "State", data: "state", render: {display: displayStateBoxes}},
                {title: "<span title=\"Release clearing state\">Clearing Status</span>", data: "clearing"},
                {title: "Actions", data: "id", render: {display: renderProjectActions}}
            ]
        });
    }

    const StatesColumnIndex = 3;
    const clearingSummaryColumnIndex = 4;

    function loadClearingStateSummaries() {
        var tableData = projectsTable.data();
        var ids = [];
        for (var i = 0; i < tableData.length; i++) {
            ids.push(tableData[i].id);
            var cell = projectsTable.cell(i, clearingSummaryColumnIndex);
            cell.data("Loading...");
        }
        jQuery.ajax({
            type: 'POST',
            url: '<%=loadClearingStateAjaxURL%>',
            cache: false,
            data: {
                "<portlet:namespace/><%=Project._Fields.ID%>": ids
            },
            success: function (response) {
                for (var i = 0; i < response.length; i++) {
                    var cell_clearingsummary = projectsTable.cell("#" + response[i].id, clearingSummaryColumnIndex);
                    cell_clearingsummary.data(displayClearingStateSummary(response[i].clearing));
                }
            },
            error: function () {
                for (var i = 0; i < tableData.length; i++) {
                    var cell = projectsTable.cell("#" + tableData[i].id, clearingSummaryColumnIndex);
                    cell.data("Failed to load");
                }
            }
        });
    }

    function displayClearingStateSummary(clearing){
        var releaseCounts;
        function d(v){return v == undefined ? "0" : v;}
        if (clearing) {
            releaseCounts = d(clearing.newRelease) + " " + d(clearing.underClearing) + " " + d(clearing.underClearingByProjectTeam) + " " + d(clearing.reportAvailable) + " " + d(clearing.approved);
        } else {
            releaseCounts = "Not available";
        }

        return "<span title=\"new release, under clearing, under clearing by the project clearing team, report available, approved\">" + releaseCounts + "</span>";
    }

    function createUrl_comp(paramId, paramVal) {
        var portletURL = PortletURL.createURL('<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.RENDER_PHASE) %>')
            .setParameter('<%=PortalConstants.PAGENAME%>', '<%=PortalConstants.PAGENAME_DETAIL%>').setParameter(paramId, paramVal);
        return portletURL.toString();
    }

    function createDetailURLfromProjectId(paramVal) {
        return createUrl_comp('<%=PortalConstants.PROJECT_ID%>', paramVal);
    }

    function exportSpreadsheet() {
        $('#keywordsearchinput').val("");
        useSearch('keywordsearchinput');

        var portletURL = PortletURL.createURL('<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.RESOURCE_PHASE) %>')
            .setParameter('<%=PortalConstants.ACTION%>', '<%=PortalConstants.EXPORT_TO_EXCEL%>');
        portletURL.setParameter('<%=Project._Fields.NAME%>', $('#project_name').val());
        portletURL.setParameter('<%=Project._Fields.TYPE%>', $('#project_type').val());
        portletURL.setParameter('<%=Project._Fields.PROJECT_RESPONSIBLE%>', $('#project_responsible').val());
        portletURL.setParameter('<%=Project._Fields.BUSINESS_UNIT%>', $('#group').val());
        portletURL.setParameter('<%=Project._Fields.STATE%>', $('#state').val());
        portletURL.setParameter('<%=Project._Fields.TAG%>', $('#tag').val());
        portletURL.setParameter('<%=PortalConstants.EXTENDED_EXCEL_EXPORT%>', $('#extendedByReleases').val());

        window.location.href = portletURL.toString();
    }

    function openSelectClearingDialog(projectId, fieldId) {
        $('#projectId').val(projectId);

        setFormSubmit(fieldId);
        fillClearingFormAndOpenDialog(projectId);
    }

    function deleteProject(projectId, name, linkedProjectsSize, linkedReleasesSize, attachmentsSize) {

        function deleteProjectInternal() {
            jQuery.ajax({
                type: 'POST',
                url: '<%=deleteAjaxURL%>',
                cache: false,
                data: {
                    "<portlet:namespace/><%=PortalConstants.PROJECT_ID%>": projectId
                },
                success: function (data) {
                    if (data.result == 'SUCCESS') {
                        projectsTable.row('#' + projectId).remove().draw(false);
                    }
                    else if (data.result == 'SENT_TO_MODERATOR') {
                        $.alert("You may not delete the project, but a request was sent to a moderator!");
                    } else if (data.result == 'IN_USE') {
                        $.alert("The project cannot be deleted, since it is used by another project!");
                    }
                    else {
                        $.alert("I could not delete the project!");
                    }
                },
                error: function () {
                    $.alert("I could not delete the project!");
                }
            });

        }

        var confirmMessage = "Do you really want to delete the project " + name + " ?";
        confirmMessage += (linkedProjectsSize > 0 || linkedReleasesSize > 0 || attachmentsSize > 0) ? "<br/><br/>The project " + name + " contains<br/><ul>" : "";
        confirmMessage += (linkedProjectsSize > 0) ? "<li>" + linkedProjectsSize + " linked projects</li>" : "";
        confirmMessage += (linkedReleasesSize > 0) ? "<li>" + linkedReleasesSize + " linked releases</li>" : "";
        confirmMessage += (attachmentsSize > 0) ? "<li>" + attachmentsSize + " attachments</li>" : "";
        confirmMessage += (linkedProjectsSize > 0 || linkedReleasesSize > 0 || attachmentsSize > 0) ? "</ul>" : "";

        deleteConfirmed(confirmMessage, deleteProjectInternal);
    }

    function fillClearingFormAndOpenDialog(projectId) {
        jQuery.ajax({
            type: 'POST',
            url: '<%=projectReleasesAjaxURL%>',
            cache: false,
            data: {
                "<portlet:namespace/><%=PortalConstants.PROJECT_ID%>": projectId
            },
            success: function (data) {
                $('#fossologyClearingTable').find('tbody').html(data);
                openDialog('fossologyClearing', 'fossologyClearingForm', .4, .5);
            },
            error: function () {
                alert("I could not get any releases!");
            }
        });
    }

    function setFormSubmit(fieldId) {
        $('#fossologyClearingForm').submit(function (e) {
            e.preventDefault();
            closeOpenDialogs();

            jQuery.ajax({
                type: 'POST',
                url: '<%=projectReleasesSendURL%>',
                cache: false,
                data: $('form#fossologyClearingForm').serialize(),
                success: function (data) {
                    if (data.result) {
                        if (data.result == "FAILURE") {
                            $('#' + fieldId).html("Error");
                        }
                        else {
                            $('#' + fieldId).html("Sent");
                        }
                    }
                },
                error: function () {
                    alert("I could not upload the files");
                }
            })

        });

    }

    function selectAll(form) {
        $(form).find(':checkbox').prop("checked", true);
    }

</script>

 <link rel="stylesheet" href="<%=request.getContextPath()%>/css/dataTable_Siemens.css">
 <link rel="stylesheet" href="<%=request.getContextPath()%>/css/sw360.css">
