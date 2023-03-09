pageextension 50120 "PCO Sales Order" extends "Sales Order"
{
    actions
    {
        modify(Release)
        {
            trigger OnBeforeAction()
            begin
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
        ReqDeliveryDateErrorInfo.AddAction(UseWorkDateLbl, Codeunit::"PCO Sales Order Errors", FillReqDateWithWorkDateLbl); // Add action for workdate
        ReqDeliveryDateErrorInfo.AddAction(UseCurrentDateLbl, Codeunit::"PCO Sales Order Errors", FillReqDateWithCurrentDateLbl); // Add action for current date
        ReqDeliveryDateErrorInfo.RecordId := Rec.RecordId(); //Add record ID

        // Throw the error
        Error(ReqDeliveryDateErrorInfo);
    end;
}
