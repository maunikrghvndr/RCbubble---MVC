<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>
<div id="enote">
    <table style="width: 100%;">
        <tr>
            <td>
                <div class='floatLeft'>
                    <% System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "eNoteCallbackPanel", "AccountDetails", new RouteValueDictionary { { "DocumentID", Model.DocumentID }, { "enote.eNoteID", ViewData["enoteID"] } }); %>
                </div>
            </td>
        </tr>
    </table>
</div>


