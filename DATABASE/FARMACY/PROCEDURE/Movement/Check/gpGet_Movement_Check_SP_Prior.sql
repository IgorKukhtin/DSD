-- Function: gpGet_Movement_Check_SP_Prior()

DROP FUNCTION IF EXISTS gpGet_Movement_Check_SP_Prior (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_SP_Prior(
   OUT outPartnerMedicalId    Integer,  -- 
   OUT outPartnerMedicalName  TVarChar,  -- 
   OUT outMedicSId            TVarChar,  -- 
   OUT outMedicSPName         TVarChar,  -- 
    IN inSession              TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId:= lpGetUserBySession (inSession);

-- vbUserId:= 4000066;

    -- Результат - ВСЕ документы - с типом "Не подтвержден"
    WITH tmpData AS (SELECT Object_PartnerMedical.Id         AS PartnerMedicalId
                          , Object_PartnerMedical.ValueData  AS PartnerMedicalName
                          , MovementString_MedicSP.ValueData AS MedicSPName
                          , Movement.Id AS MovementId
                          , Movement.OperDate
                            --  № п/п
                          , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                       AND MovementLinkObject_Insert.DescId     = zc_MovementLinkObject_Insert()
                                                       AND MovementLinkObject_Insert.ObjectId   = vbUserId
                         LEFT JOIN MovementString AS MovementString_MedicSP
                                                  ON MovementString_MedicSP.MovementId = Movement.Id
                                                 AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                       ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                                      AND MovementLinkObject_PartnerMedical.DescId     = zc_MovementLinkObject_PartnerMedical()
                                                      AND MovementLinkObject_PartnerMedical.ObjectId   > 0
                         LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId
                     WHERE Movement.DescId   =  zc_Movement_Check()
                       AND Movement.StatusId =  zc_Enum_Status_Complete()
                       AND Movement.OperDate >=  CURRENT_DATE - INTERVAL '31 DAY'
                     ORDER BY Movement.Id DESC
                    )
    -- Результат
    SELECT COALESCE (tmpData.PartnerMedicalId, 0)
         , COALESCE (tmpData.PartnerMedicalName, '')
         , 0 AS MedicSPId
         , COALESCE (tmpData.MedicSPName, '')
           INTO outPartnerMedicalId
              , outPartnerMedicalName
              , outMedicSId
              , outMedicSPName
    FROM (SELECT 1 AS xxx) AS tmp
         LEFT JOIN tmpData ON tmpData.Ord = 1
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.01.18                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Check_SP_Prior (inSession:= '4000066')
