-- Function: gpSelect_Movement_Sale_Email_list(TVarChar)

-- DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Email_list (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Email_list (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Email_list(
    IN inIsExcel              Boolean,    -- сессия пользователя
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer
             , InvNumber TVarChar
             , OperDate_protocol TDateTime, OperDate TDateTime
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , JuridicalName_To TVarChar, OKPO_To TVarChar
             , RetailName TVarChar
             , ExportKindId Integer
             , zc_Logistik41750857 Integer
             , zc_Nedavn2244900110 Integer
             , isExcel Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);



     -- Результат
     RETURN QUERY
        WITH tmpExportJuridical AS (SELECT DISTINCT tmp.PartnerId, tmp.ExportKindId
                                    FROM lpSelect_Object_ExportJuridical_list() AS tmp
                                    -- только для этого
                                    WHERE tmp.ExportKindId IN (zc_Enum_ExportKind_Glad2514900150()
                                                              )
                                    --AND inIsExcel = FALSE
                                   UNION
                                    SELECT DISTINCT tmp.PartnerId, tmp.ExportKindId
                                    FROM lpSelect_Object_ExportJuridical_list() AS tmp
                                    -- только для этого
                                    WHERE tmp.ExportKindId IN (zc_Enum_ExportKind_Logistik41750857()
                                                              )
                                    --AND inIsExcel = TRUE
                                   UNION
                                    SELECT DISTINCT tmp.PartnerId, tmp.ExportKindId
                                    FROM lpSelect_Object_ExportJuridical_list() AS tmp
                                    -- только для этого
                                    WHERE tmp.ExportKindId IN (zc_Enum_ExportKind_Nedavn2244900110()
                                                              )
                                   UNION
                                    SELECT DISTINCT tmp.PartnerId, tmp.ExportKindId
                                    FROM lpSelect_Object_ExportJuridical_list() AS tmp
                                    -- только для этого
                                    WHERE tmp.isAuto = TRUE

                                   UNION
                                    SELECT DISTINCT tmp.PartnerId, tmp.ExportKindId
                                    FROM lpSelect_Object_ExportJuridical_list() AS tmp
                                    -- только для этого
                                    WHERE tmp.ExportKindId = zc_Enum_ExportKind_Tavr31929492()
                                    --AND vbUserId = 5
                                    --AND inIsExcel = TRUE
                                   )

                  , tmpMovement AS (SELECT Movement.Id AS MovementId
                                         , Movement.InvNumber
                                         , Movement.OperDate
                                         , MovementLinkObject_To.ObjectId AS ToId
                                         , tmpExportJuridical.ExportKindId
                                    FROM Movement
                                         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                         INNER JOIN tmpExportJuridical ON tmpExportJuridical.PartnerId = MovementLinkObject_To.ObjectId
                                         LEFT JOIN MovementBoolean AS MovementBoolean_Mail
                                                                   ON MovementBoolean_Mail.MovementId = Movement.Id
                                                                  AND MovementBoolean_Mail.DescId     = zc_MovementBoolean_Mail()
                                                                  AND MovementBoolean_Mail.ValueData  = TRUE

                                    WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '7 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                                      AND Movement.DescId = zc_Movement_Sale()
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                      AND (MovementBoolean_Mail.MovementId IS NULL
                                      --OR Movement.Id = 27974591
                                          )
                                    --AND (MovementBoolean_Mail.MovementId IS NULL OR tmpExportJuridical.ExportKindId IN (zc_Enum_ExportKind_Nedavn2244900110()))
                                  --LIMIT CASE WHEN tmpExportJuridical.ExportKindId = zc_Enum_ExportKind_Logistik41750857() THEN 1 ELSE 100 END
                                   )
               , tmpMovProtocol AS (SELECT tmpMovement.*
                                         , MovementProtocol.OperDate AS OperDate_protocol
                                           -- № п/п
                                         , ROW_NUMBER() OVER (PARTITION BY tmpMovement.MovementId ORDER BY MovementProtocol.OperDate ASC) AS Ord
                                    FROM tmpMovement
                                         LEFT JOIN MovementProtocol ON MovementProtocol.MovementId = tmpMovement.MovementId
                                   )
        -- Результат
        SELECT tmpMovProtocol.MovementId
             , tmpMovProtocol.InvNumber
             , tmpMovProtocol.OperDate_protocol
             , tmpMovProtocol.OperDate
             , MovementDate_OperDatePartner.ValueData            AS OperDatePartner
             , MovementString_InvNumberPartner.ValueData         AS InvNumberPartner
             , Object_From.Id                                    AS FromId
             , Object_From.ValueData                             AS FromName
             , Object_To.Id                                      AS ToId
             , Object_To.ValueData                               AS ToName
             , Object_JuridicalTo.ValueData                      AS JuridicalName_To
             , ObjectHistory_JuridicalDetails_View.OKPO          AS OKPO_To
             , Object_Retail.ValueData                           AS RetailName
             
             , tmpMovProtocol.ExportKindId                       AS ExportKindId
             , zc_Enum_ExportKind_Logistik41750857() :: Integer  AS zc_Logistik41750857
             , zc_Enum_ExportKind_Nedavn2244900110() :: Integer  AS zc_Nedavn2244900110

             , CASE WHEN tmpMovProtocol.ExportKindId = zc_Enum_ExportKind_Logistik41750857() THEN TRUE ELSE FALSE END :: Boolean AS isExcel

        FROM tmpMovProtocol
             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                    ON MovementDate_OperDatePartner.MovementId = tmpMovProtocol.MovementId
                                   AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
             LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                      ON MovementString_InvNumberPartner.MovementId = tmpMovProtocol.MovementId
                                     AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = tmpMovProtocol.MovementId
                                         AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

             LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovProtocol.ToId
             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                  ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                 AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
             LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
             LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalTo.Id

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = Object_JuridicalTo.Id
                                 AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Partner_Juridical.ChildObjectId

        WHERE tmpMovProtocol.Ord = 1
          AND tmpMovProtocol.OperDate_protocol <= CURRENT_TIMESTAMP - INTERVAL '1 HOUR'
       ;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.01.21                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_Email_list (inIsExcel:= TRUE, inSession:= zfCalc_UserAdmin())
