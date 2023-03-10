pageextension 50121 "PCO Sales Order List" extends "Sales Order List"
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
        ReqDeliveryDateErrorInfo: ErrorInfo;
        MissingReqDeliveryDateLbl: Label 'Missing Requested Delivery Date';
        MissingValueErr: Label 'Requested delivery date requires a value.';
    begin
        case true of
            Rec.Status = Enum::"Sales Document Status"::Released,
            Rec."Requested Delivery Date" <> 0D:
                exit;
        end;

        // Define the error
        ReqDeliveryDateErrorInfo := ErrorInfo.Create(MissingValueErr);
        ReqDeliveryDateErrorInfo.Title := MissingReqDeliveryDateLbl;

        // Add actions to error message
        ReqDeliveryDateErrorInfo.AddNavigationAction();

        // Add record ID we want to navigate to
        ReqDeliveryDateErrorInfo.RecordId := Rec.RecordId();

        // Throw the error
        Error(ReqDeliveryDateErrorInfo);
    end;
}
