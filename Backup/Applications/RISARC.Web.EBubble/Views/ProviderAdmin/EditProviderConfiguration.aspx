<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Setup.Model.ProviderConfiguration>" %>

<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit Your Provider's Configuration
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Edit Your Provider's Configuration</h2>
    <% Html.RenderPartial("BackToProviderLink"); %>
    <p class="Instructions">
        Update Configuration below
    </p>
    <%= Html.ValidationInstructionHeader() %>

    <h3>Provider Configuration</h3>
    <%using (Html.BeginForm())
      { %>
    <ul>
        <li>
            <label>
                Release Form</label>
            <div id="divPreviewLink">
                <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "PreviewComplianceFileLink", "ProviderAdmin", new { providerId = ViewData["ProviderId"] }); %>
            </div>
        </li>
        <li>
            <%--<%= Html.ActionLink("Upload New Release Form", "EditPoviderComplianceForm")%>        --%>
            <a id="aUploadReleaseForm" href="javascript:void(0);" onclick="return ShowFileUploadControl();">Upload New Release Form</a>
            <br /><br />
            <% Html.RenderPartial("pvSingleFileUpload"); %>
        </li>
        <li>
            <label>
                Price Per Document Page <span class="ValidationInstructor">*</span></label>

            <%= Html.TextBox("PricePerDocumentPage", String.Format("{0:F}", Model.PricePerDocumentPage), new { @class = "input_text", @readonly = "readonly" })%>
            <%---Mike: original from line above <%= Html.StyledTextBox("PricePerDocumentPage", String.Format("{0:F}", Model.PricePerDocumentPage) )%>--%>
            <%= Html.ValidationMessage("PricePerDocumentPageRequiredInvalid", "Required and must be a decimal with no $ sign.")%>

            <div class="FieldInstructions">Must be a decimal with no <i>$</i> sign.</div>
            <div class="FieldInstructions">
                This will determine how much a document costs when the pages of the document's file can be counted.  
            In this case, the <i>Price Per Document Page</i> will be multiplied by the number of pages in the file to calculate the document cost.
            </div>
        </li>
        <li>
            <label>
                Price Per Document Megabyte <span class="ValidationInstructor">*</span></label>
            <%= Html.TextBox("PricePerDocumentMegabyte", String.Format("{0:F}", Model.PricePerDocumentMegabyte), new { @class = "input_text", @readonly = "readonly"})%>

            <%--<%=-Mike: original from line above  Html.StyledTextBox("PricePerDocumentMegabyte", String.Format("{0:F}", Model.PricePerDocumentMegabyte)) %>--%>

            <%= Html.ValidationMessage("PricePerDocumentMegabyteRequiredInvalid", "Required and must be a decimal with no $ sign.")%>
            <div class="FieldInstructions">Must be a decimal with no <i>$</i> sign.</div>
            <div class="FieldInstructions">
                This will determine how much a document costs when the pages of the document's file CANNOT be counted.  
            In this case, the <i>Price Per Document Multiplied</i> will be multiplied by the size, in Megabytes, of the file to calculate the document cost.
            </div>
        </li>
        <li>
            <label>
                Minimum Document Price <span class="ValidationInstructor">*</span></label>
            <% string formattedLowestMinimum = String.Format("{0:F}", ViewData["LowestMinimumDocumentPrice"]); %>

            <%= Html.TextBox("MinimumDocumentPrice", String.Format("{0:F}", Model.MinimumDocumentPrice), new { @class = "input_text", @readonly = "readonly"})%>
            <%--Mike: original from line above <%= Html.StyledTextBox("MinimumDocumentPrice", String.Format("{0:F}", Model.MinimumDocumentPrice)) %>--%>

            <%= Html.ValidationMessage("MinimumDocumentPriceRequiredInvalid", "Required and must be a decimal with no $ sign.") %>
            <%= Html.ValidationMessage("MinimumDocumentPriceBelowMinimum", "Must be at least " + formattedLowestMinimum + "")%>
            <div class="FieldInstructions">Must be a decimal with no <i>$</i> sign, and greater than <%= formattedLowestMinimum %>.</div>
            <div class="FieldInstructions">This will determine the minimum cost of documents.  If the calculated cost is less than the minimum cost, the cost will be adjusted to equal the minimum cost.</div>
        </li>
        <li>
            <fieldset>
                <label>Set document cost settings for Exchange Partners:</label>
                <%=Html.Action("GridViewUserCostSettingsPartial")%>
            </fieldset>
            
        </li>
        <li>
            <input type="submit" value="Update Provider Configuration" />
        </li>
    </ul>
    <%} %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script src="<%: Url.Content("~/Scripts/jquery.validate.js")%>" type="text/javascript"></script>
    <script src="<%: Url.Content("~/Scripts/jquery.validate.unobtrusive.js")%>" type="text/javascript"></script>
    <script type="text/javascript">
        $.validator.unobtrusive.adapters.add('dynamicrange', ['minvalueproperty', 'maxvalueproperty'],
            function (options) {
                options.rules['dynamicrange'] = options.params;
                if (options.message != null) {
                    $.validator.messages.dynamicrange = options.message;
                }
            }
        );

        $.validator.addMethod('dynamicrange', function (value, element, params) {
            var minValue = parseInt($('input[name="' + params.minvalueproperty + '"]').val(), 10);
            var maxValue = parseInt($('input[name="' + params.maxvalueproperty + '"]').val(), 10);
            var currentValue = parseInt(value, 10);
            if (isNaN(minValue) || isNaN(maxValue) || isNaN(currentValue) || minValue >= currentValue || currentValue >= maxValue) {
                var message = $(element).attr('data-val-dynamicrange');
                $.validator.messages.dynamicrange = $.format(message, minValue, maxValue);
                return false;
            }
            return true;
        }, '');
    </script>
</asp:Content>
