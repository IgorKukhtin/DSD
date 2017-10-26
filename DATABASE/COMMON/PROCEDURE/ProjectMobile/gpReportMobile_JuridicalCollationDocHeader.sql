-- Function: gpReportMobile_JuridicalCollationDocHeader

DROP FUNCTION IF EXISTS gpReportMobile_JuridicalCollationDocHeader (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReportMobile_JuridicalCollationDocHeader (
    IN inMovementId Integer  , -- ИД документа
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id              Integer
             , InvNumber       TVarChar
             , OperDate        TDateTime
             , ContractNumber  TVarChar
             , ContractTagName TVarChar
             , PartnerName     TVarChar 
             , isPriceWithVAT  Boolean
             , TotalCountKg    TFloat
             , TotalSummPVAT   TFloat
             , TotalSumm       TFloat
             , ChangePercent   TFloat
              )
AS $BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- Результат
      RETURN QUERY 
        SELECT Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , COALESCE (Object_Contract.ValueData, '')::TVarChar          AS ContractNumber
             , COALESCE (Object_ContractTag.ValueData, '')::TVarChar       AS ContractTagName
             , CASE Movement.DescId
                    WHEN zc_Movement_Sale() THEN Object_To.ValueData
                    WHEN zc_Movement_ReturnIn() THEN Object_From.ValueData
                    ELSE ''::TVarChar
               END AS PartnerName
             , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)    AS isPriceWithVAT
             , COALESCE (MovementFloat_TotalCountKg.ValueData, 0)::TFloat  AS TotalCountKg
             , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0)::TFloat AS TotalSummPVAT
             , COALESCE (MovementFloat_TotalSumm.ValueData, 0)::TFloat     AS TotalSumm
             , COALESCE (MovementFloat_ChangePercent.ValueData, 0)::TFloat AS ChangePercent
        FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId                            
             LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                  ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                 AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
             LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                       ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
             LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                     ON MovementFloat_TotalCountKg.MovementId = Movement.Id
                                    AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                     ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                     ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
             LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
        WHERE Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
          AND Movement.Id = inMovementId;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Ярошенко Р.Ф.
 15.09.17                                                                         *
*/

-- SELECT * FROM gpReportMobile_JuridicalCollationDocHeader (inMovementId:= 5280790, inSession:= zfCalc_UserAdmin());
