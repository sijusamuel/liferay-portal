<%--
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>
<%@ include file="/html/portlet/wiki/init.jsp" %>

<%
WikiPage wikiPage = (WikiPage)request.getAttribute("edit_page.jsp-wikiPage");

String format = BeanParamUtil.getString(wikiPage, request, "format", WikiPageConstants.DEFAULT_FORMAT);

String content = BeanParamUtil.getString(wikiPage, request, "content");

String toggleId = renderResponse.getNamespace() + "toggle_id_wiki_editor_help";

String toggleValue = SessionClicks.get(request, toggleId, null);

boolean showSyntaxHelp = ((toggleValue != null) && toggleValue.equals("block"));
%>

<div align="right">
	<liferay-ui:toggle
		defaultShowContent="<%= false %>"
		hideMessage='<%= LanguageUtil.get(pageContext, "hide-syntax-help") + " &raquo;" %>'
		id="<%= toggleId %>"
		showMessage='<%= "&laquo; " + LanguageUtil.get(pageContext, "show-syntax-help") %>'
	/>
</div>

<div>
	<aui:layout>
		<aui:column columnWidth="<%= showSyntaxHelp ? 70 : 100 %>" id="wikiEditorContainer">

			<%
			long resourcePrimKey = 0;

			String attachmentURLPrefix = StringPool.BLANK;

			if (wikiPage != null) {
				resourcePrimKey = wikiPage.getResourcePrimKey();

				attachmentURLPrefix = themeDisplay.getPortalURL() + themeDisplay.getPathMain() + "/wiki/get_page_attachment?p_l_id=" + themeDisplay.getPlid() + "&nodeId=" + wikiPage.getNodeId() + "&title=" + HttpUtil.encodeURL(wikiPage.getTitle()) + "&fileName=";
			}

			Map<String,String> configParams = new HashMap();

			configParams.put("attachmentURLPrefix", attachmentURLPrefix);
			configParams.put("wikiPageResourcePrimKey", String.valueOf(resourcePrimKey));

			Map<String,String> fileBrowserParams = new HashMap();

			fileBrowserParams.put("attachmentURLPrefix", attachmentURLPrefix);
			fileBrowserParams.put("Type", "Attachment");
			fileBrowserParams.put("wikiPageResourcePrimKey", String.valueOf(resourcePrimKey));
			%>

			<liferay-ui:input-editor
				configParams="<%= configParams %>"
				editorImpl="<%= EDITOR_WYSIWYG_IMPL_KEY %>"
				fileBrowserParams="<%= fileBrowserParams %>"
				toolbarSet="creole"
				width="100%"
			/>

			<aui:input name="content" type="hidden" />
		</aui:column>

		<aui:column columnWidth="30" cssClass="syntax-help" id="toggle_id_wiki_editor_help" style='<%= showSyntaxHelp ? StringPool.BLANK : "display: none" %>'>
			<h3>
				<liferay-ui:message key="syntax-help" />
			</h3>

			<liferay-util:include page="<%= WikiUtil.getHelpPage(format) %>" />

			<aui:a href="<%= WikiUtil.getHelpURL(format) %>" target="_blank"><liferay-ui:message key="learn-more" /> &raquo;</aui:a>
		</aui:column>
	</aui:layout>
</div>

<aui:script>
	function <portlet:namespace />initEditor() {
		return "<%= UnicodeFormatter.toString(content) %>";
	}
</aui:script>

<aui:script use="aui-base">
	var CSS_EDITOR_WIDTH = 'aui-w70';

	var CSS_EDITOR_WIDTH_EXPANDED = 'aui-w100';

	Liferay.on(
		'toggle:stateChange',
		function(event) {
			var id = event.id;

			if (id === '<%= toggleId %>') {
				var state = event.state;

				var classSrc = CSS_EDITOR_WIDTH;
				var classDest = CSS_EDITOR_WIDTH_EXPANDED;

				var visible = (state === 1);

				if (visible) {
					classSrc = CSS_EDITOR_WIDTH_EXPANDED;
					classDest = CSS_EDITOR_WIDTH;
				}

				var editorContainer = A.one('#<portlet:namespace />wikiEditorContainer');

				editorContainer.replaceClass(classSrc, classDest);

				if (visible && A.UA.webkit) {
					var editorFrame = editorContainer.one('iframe');

					if (editorFrame) {
						editorFrame.hide();

						A.later(0, editorFrame, 'show');
					}
				}

				var editorInstance = window['<portlet:namespace />editor'];

				if (editorInstance) {
					editorInstance.focus();
				}
			}
		}
	);
</aui:script>

<%!
public static final String EDITOR_WYSIWYG_IMPL_KEY = "editor.wysiwyg.portal-web.docroot.html.portlet.wiki.edit.creole.jsp";
%>