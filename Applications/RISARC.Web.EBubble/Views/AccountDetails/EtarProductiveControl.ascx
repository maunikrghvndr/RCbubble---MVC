<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.ProductivityTimeTracker>" %>

<div class="FOHeaderDetails">
    <ul>
        <% 
            string noOftarFilesReviewed = "0";
            string tcnProductiveTime = "00:00:00";
            string noOfeNotesReviewed = "0";
            string eNotesProductiveTime = "00:00:00";
            string TotalProductiveTime = "00:00:00";

            if (Model !=null)
            {
                noOftarFilesReviewed = Model.NumberOfTARFormsReviewed;
                tcnProductiveTime = Model.TCNProductiveTime;
                noOfeNotesReviewed = Model.NumberOfENotesReviewed;
                eNotesProductiveTime = Model.ENotesProductiveTime;
                TotalProductiveTime = Model.TotalProductiveTime;    
            }
        %>
        <li><span class="lightGreenTxt"># of TAR:</span> <%= noOftarFilesReviewed%> </li>
        <li><span class="lightGreenTxt">TCN Productive Time:</span> <%= tcnProductiveTime%></li>
        <li><span class="lightGreenTxt"># of e-Notes:</span> <%= noOfeNotesReviewed%></li>
        <li><span class="lightGreenTxt">e-Notes Productive Time:</span> <%= eNotesProductiveTime%></li>
        <li><span class="lightGreenTxt">Total Productive Time:</span> <%= TotalProductiveTime%></li>
    </ul>
</div>
