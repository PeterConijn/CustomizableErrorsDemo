pageextension 50120 "PCO Sales Order" extends "Sales Order"
{
    actions
    {
        modify(Release)
        {
            trigger OnBeforeAction()
            begin
                CheckExternalDocumentNo();
                CheckRequestedDeliveryDate();
            end;
        }
    }

    local procedure CheckRequestedDeliveryDate()
    var
        MissingValueErr: Label 'Requested delivery date requires a value.';
        FillReqDateWithWorkDateLbl: Label 'FillRequestedDeliveryDateWithWorkDate', Locked = true;
        FillReqDateWithCurrentDateLbl: Label 'FillRequestedDeliveryDateWithCurrentDate', Locked = true;
        UseWorkDateLbl: Label 'Use Workdate';
        UseCurrentDateLbl: Label 'Use Current Date';
        MissingReqDeliveryDateLbl: Label 'Missing Requested Delivery Date';
        ReqDeliveryDateErrorInfo: ErrorInfo;
    begin
        case true of
            Rec.Status = Enum::"Sales Document Status"::Released,
            Rec."Requested Delivery Date" <> 0D:
                exit;
        end;

        // Define the error
        ReqDeliveryDateErrorInfo := ErrorInfo.Create(MissingValueErr);
        ReqDeliveryDateErrorInfo.Title := MissingReqDeliveryDateLbl;

        // Add action for workdate
        ReqDeliveryDateErrorInfo.AddAction(UseWorkDateLbl, Codeunit::"PCO Sales Order Errors", FillReqDateWithWorkDateLbl);
        ReqDeliveryDateErrorInfo.AddAction(UseCurrentDateLbl, Codeunit::"PCO Sales Order Errors", FillReqDateWithCurrentDateLbl);

        // Add record ID since we will need that for our actions
        ReqDeliveryDateErrorInfo.RecordId := Rec.RecordId();

        // Throw the error
        Error(ReqDeliveryDateErrorInfo);
    end;

    local procedure CheckExternalDocumentNo()
    var
        MissingValueErr: Label 'External document no. needs to have a value in sales order %1', Comment = '%1 = The sales order no. with the missing value';
    begin
        if Rec."External Document No." = '' then
            Error(MissingValueErr, Rec."No.");
    end;
}
