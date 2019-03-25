<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Payment.Model.InvoiceInfo>" %>
<h3> Enter Information of Person to be Invoiced</h3>
<ul>
    <li>
        <label for="CardHolderName">
            Full Name <span class="ValidationInstructor">*</span></label>
        <%= Html.StyledTextBox("InvoiceeName", Model.InvoiceeName) %>
        <%= Html.ValidationMessage("InvoiceeNameRequired", "Required")%>
    </li>
    <li><label for="InvoiceeAddress.StreetAddress">Address to Send Invoice To</label>
        <ul><% ViewDataDictionary addressInfoDictionary = new ViewDataDictionary();
               addressInfoDictionary.SetValue(GlobalViewDataKey.BindingPrefix, "InvoiceeAddress.");
               addressInfoDictionary.ModelState.Merge(ViewData.ModelState);
               Html.RenderPartial("AddressInfo", Model.InvoiceeAddress, addressInfoDictionary); %>
               
        </ul>
    </li>
    <li>
    <label for="PhoneAreaCode">
        Phone <span class="ValidationInstructor">*</span></label>
    <% ViewDataDictionary primaryPhoneInfoDictionary = new ViewDataDictionary();
       primaryPhoneInfoDictionary.SetValue(GlobalViewDataKey.BindingPrefix, "InvoiceePhone.");
       primaryPhoneInfoDictionary.ModelState.Merge(ViewData.ModelState);

       Html.RenderPartial("PhoneInfo", Model.InvoiceePhone, primaryPhoneInfoDictionary); %>
    </li>
    <li>
        <input type="submit" value="Invoice Above Person for Document" />
    </li>
 </ul>

