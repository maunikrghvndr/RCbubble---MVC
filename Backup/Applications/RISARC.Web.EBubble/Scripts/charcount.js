 
            var wordCount = 0;
            function CharCount() {
                var text1 = trim(document.getElementById('Comments').value);
                var text1 = oldtrim(document.getElementById('Comments').value);
                if (text1.length > -1) {
                    document.getElementById('CharCountDisplay').innerHTML = "Char Count: " + (text1.length);
                }
                else {
                    document.getElementById('CharCountDisplay').innerHTML = "";
                }
            }

            function trim(stringToTrim) {
                //return stringToTrim.replace(/^\s+|\s+$/g, "");
                return stringToTrim.replace(/^s*|s(?=s)|s*$/g, "");
            }
            function ltrim(stringToTrim) {
                return stringToTrim.replace(/^\s+/, "");
            }
            function rtrim(stringToTrim) {
                return stringToTrim.replace(/\s+$/, "");
            }
            // works for old browsers
            function oldltrim(str) {
                for (var k = 0; k < str.length && isWhitespace(str.charAt(k)); k++);
                return str.substring(k, str.length);
            }
            function oldrtrim(str) {
                for (var j = str.length - 1; j >= 0 && isWhitespace(str.charAt(j)); j--);
                return str.substring(0, j + 1);
            }
            function oldtrim(str) {
                return ltrim(rtrim(str));
            }
            function oldisWhitespace(charToCheck) {
                var whitespaceChars = " \t\n\r\f";
                return (whitespaceChars.indexOf(charToCheck) != -1);
            }
            // for old browsers
            function ProcessOnChange(DrpDwnID) {
                //var Drp = document.getElementById(DrpDwnID);
                //Drp.Value
                //alert("OK - its working now..."  );
                // Set all to defualt
                //document.getElementById('manualACNHolderLINK').innerHTML = 'Enter Payor Identifier';
                //document.getElementById('ManualACNNumberG6').innerHTML = '(Optional) Enter Payor Identifier to manually assign to requested document';
                //document.getElementById('AccountNumIdentification').innerHTML = 'Account Number';
                //document.getElementById('AccountNum').innerHTML = 'Account Number';
                //document.getElementById("MemNumDiv").style.display = "none";
                //document.getElementById("HicNumDiv").style.display = "none";
                //document.getElementById('ManualACNNumberG6').style.display = "block";
                //document.getElementById('ManualACNNumber').style.display = "block";
                //document.getElementById('manualACNHolderLINK').style.display = "none";

                //if (document.getElementById("recipientProviderId").value == "15" || document.getElementById("recipientProviderId").value == "307" || document.getElementById("recipientProviderId").value == "368" || document.getElementById("recipientProviderId").value == "367" || document.getElementById("recipientProviderId").value == "469" || document.getElementById("recipientProviderId").value == "316" || document.getElementById("recipientProviderId").value == "317" || document.getElementById("recipientProviderId").value == "305" || document.getElementById("recipientProviderId").value == "2387" || document.getElementById("recipientProviderId").value == "2393" || document.getElementById("recipientProviderId").value == "299" || document.getElementById("recipientProviderId").value == "304" || document.getElementById("recipientProviderId").value == "307" || document.getElementById("recipientProviderId").value == "469" || document.getElementById("recipientProviderId").value == "308" || document.getElementById("recipientProviderId").value == "309" || document.getElementById("recipientProviderId").value == "313" || document.getElementById("recipientProviderId").value == "315" || document.getElementById("recipientProviderId").value == "314" || document.getElementById("recipientProviderId").value == "310" || document.getElementById("recipientProviderId").value == "323" || document.getElementById("recipientProviderId").value == "316" || document.getElementById("recipientProviderId").value == "317") {
                //    //document.getElementById("manualACNHolderLINK").setAttribute("text", "");
                //    //                    document.getElementById("MemNumDiv").style.display = "block";
                //    //                    document.getElementById("MemNumDiv").innerHTML = "H.I.C. Number"
                //    //                    document.getElementById("HicNumDiv").style.display = "block";
                //    //                    document.getElementById("ClaimIDDiv").style.display = "none";
                //    document.getElementById('manualACNHolderLINK').innerHTML = 'Internal control number (ICN) OR Document control number (DCN)';
                //    document.getElementById('ManualACNNumberG6').innerHTML = '(Required) Please Enter Internal control number (ICN) OR Document control number (DCN)*';
                //    //                    document.getElementById('AccountNumIdentification').innerHTML = 'H.I.C. Number';
                //    //                    document.getElementById('AccountNum').innerHTML = 'Health Insurance Claim Number';
                //    document.getElementById('ManualACNNumberG6').style.display = "block";
                //    document.getElementById('ManualACNNumber').style.display = "block";
                //}
                //else if (document.getElementById("recipientProviderId").value == "16") {
                //    document.getElementById("MemNumDiv").style.display = "block";
                //    //                    document.getElementById("ClaimIDDiv").style.display = "none";
                //    document.getElementById("HicNumDiv").style.display = "none";
                //    document.getElementById('manualACNHolderLINK').style.display = "none";
                //    //                    document.getElementById("CaseIDDiv").style.display = "none";
                //    document.getElementById('ManualACNNumberG6').style.display = "block";
                //    document.getElementById('ManualACNNumber').style.display = "block";
                //    document.getElementById('ManualACNNumberG6').innerHTML = 'Claim Number <span class="ValidationInstructor">*</span>';
                //}
                //else if (document.getElementById("recipientProviderId").value == "5000") {
                //    document.getElementById('manualACNHolderLINK').innerHTML = 'Request ID';
                //    document.getElementById('ManualACNNumberG6').innerHTML = '(Required) Please Enter The Request ID';
                //    document.getElementById("HicNumDiv").style.display = "none";
                //    //                    document.getElementById("CaseIDDiv").style.display = "none";
                //    document.getElementById('ManualACNNumberG6').style.display = "block";
                //    document.getElementById('ManualACNNumber').style.display = "block";
                //    //  document.getElementById('manualACNHolderLINK').innerHTML = 'Request ID';
                //    // document.getElementById('ManualACNNumberG6').innerHTML = '(Required) Please Enter Internal Control Number';
                //    // document.getElementById('ManualACNNumberG6').innerHTML = 'Claim Number Is Required If Member Number Is Not Avaliable';
                //}



            }
            //              document.getElementById("ClaimIDDiv").style.display = "none";




 