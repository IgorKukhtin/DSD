-- Function: gpSelect_Movement_Email_xls_Header_Send(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_Email_xls_Header_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Email_xls_Header_Send(
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Title TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbPartnerId Integer;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbOperDate        TDateTime;

   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbGoodsPropertyId_basis Integer;
   DECLARE vbExportKindId Integer;

   DECLARE vbPaidKindId Integer;
   DECLARE vbChangePercent TFloat;

   DECLARE vbIsChangePrice Boolean;
   DECLARE vbIsDiscountPrice Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);


     -- параметры из документа
     RETURN QUERY
     SELECT ('№ ' || tmp.InvNumber
      || CHR (13) || 'от ' ||zfConvert_DateToString (tmp.OperDatePartner)
      || CHR (13) || tmp.FromName
      || CHR (13) || tmp.ToName
            ) :: TBlob
     FROM (SELECT Movement.InvNumber
                , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                , Object_From.ValueData AS FromName
                , Object_To.ValueData AS ToName
           FROM Movement
                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                      AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                LEFT JOIN Object AS Object_To   ON Object_To.Id   = MovementLinkObject_To.ObjectId
                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
           WHERE Movement.Id = inMovementId
          ) AS tmp
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.04.21                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Email_xls_Header_Send (inMovementId:= 19371076, inSession:= zfCalc_UserAdmin())
