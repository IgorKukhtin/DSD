-- Function: gpGet_Movement_Check_SP_Prior()

DROP FUNCTION IF EXISTS gpGet_Movement_Check_SP_Prior (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_SP_Prior(
   OUT outPartnerMedicalId    Integer,   -- 
   OUT outPartnerMedicalName  TVarChar,  -- 
   OUT outMedicSId            TVarChar,  -- 
   OUT outMedicSPName         TVarChar,  -- 
   OUT outOperDateSP          TVarChar,  -- 
   OUT outSPKindId            Integer,   -- 
   OUT outSPKindName          TVarChar,  -- 
   OUT outMemberSPId          Integer,   -- 
   OUT outMemberSPName        TVarChar,  -- 
   OUT outGroupMemberSP       TVarChar,  -- 
   OUT outPassport            TVarChar,  -- 
   OUT outInn                 TVarChar,  -- 
   OUT outAddress             TVarChar,  -- 
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


IF inSession = zfCalc_UserAdmin() then vbUserId:= 4000066; end if;


    -- Результат - ВСЕ документы - с типом "Не подтвержден"
    WITH tmpData AS (SELECT Object_PartnerMedical.Id           AS PartnerMedicalId
                          , Object_PartnerMedical.ValueData    AS PartnerMedicalName
                          , MovementString_MedicSP.ValueData   AS MedicSPName
                          , MovementDate_OperDateSP.ValueData  AS OperDateSP
                          , Movement.Id AS MovementId
                          , Movement.OperDate
                          , Object_SPKind.Id                   AS SPKindId
                          , Object_SPKind.ValueData            AS SPKindName
                          , Object_MemberSP.Id                 AS MemberSPId
                          , Object_MemberSP.ValueData          AS MemberSPName
                          , Object_GroupMemberSP.ValueData     AS GroupMemberSPName
                          , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport
                          , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN
                          , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address

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

                         LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                                ON MovementDate_OperDateSP.MovementId = Movement.Id
                                               AND MovementDate_OperDateSP.DescId     = zc_MovementDate_OperDateSP()

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                                      ON MovementLinkObject_MemberSP.MovementId = Movement.Id
                                                     AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
                         LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                      ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                                     AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                         LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_MemberSP_GroupMemberSP
                                              ON ObjectLink_MemberSP_GroupMemberSP.ObjectId = Object_MemberSP.Id
                                             AND ObjectLink_MemberSP_GroupMemberSP.DescId = zc_ObjectLink_MemberSP_GroupMemberSP()
                         LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = ObjectLink_MemberSP_GroupMemberSP.ChildObjectId

                         LEFT JOIN ObjectString AS ObjectString_Address
                                                ON ObjectString_Address.ObjectId = Object_MemberSP.Id
                                               AND ObjectString_Address.DescId = zc_ObjectString_MemberSP_Address()
                         LEFT JOIN ObjectString AS ObjectString_INN
                                                ON ObjectString_INN.ObjectId = Object_MemberSP.Id
                                               AND ObjectString_INN.DescId = zc_ObjectString_MemberSP_INN()
                         LEFT JOIN ObjectString AS ObjectString_Passport
                                                ON ObjectString_Passport.ObjectId = Object_MemberSP.Id
                                               AND ObjectString_Passport.DescId = zc_ObjectString_MemberSP_Passport()

                     WHERE Movement.DescId   =  zc_Movement_Check()
                       AND Movement.StatusId =  zc_Enum_Status_Complete()
                       AND Movement.OperDate >=  CURRENT_DATE - INTERVAL '51 DAY'
                     ORDER BY Movement.Id DESC
                    )
    -- Результат
    SELECT COALESCE (tmpData.PartnerMedicalId, 0)
         , COALESCE (tmpData.PartnerMedicalName, '')
         , 0 AS MedicSPId
         , COALESCE (tmpData.MedicSPName, '')
           -- вернуть через строчку, т.к. с TDateTime - ошибка
         , zfConvert_DateToString (COALESCE (tmpData.OperDateSP, CURRENT_DATE))
         , SPKindId
         , SPKindName
         , MemberSPId
         , MemberSPName
         , GroupMemberSPName
         , Passport
         , INN
         , Address         
    INTO outPartnerMedicalId
       , outPartnerMedicalName
       , outMedicSId
       , outMedicSPName
       , outOperDateSP
       
       , outSPKindId
       , outSPKindName
       , outMemberSPId
       , outMemberSPName
       , outGroupMemberSP
       , outPassport
       , outInn
       , outAddress

    FROM (SELECT 1 AS xxx) AS tmp
         LEFT JOIN tmpData ON tmpData.Ord = 1
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 23.01.19                                                                      *
 23.01.18                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Check_SP_Prior (inSession:= '4000066')
