-- Function: gpGet_Movement_Check_SP_Prior()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_SP_Prior (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_SP_Prior(
    IN inUnitId               Integer,  -- 
    IN inSession              TVarChar   -- сессия пользователя
)
RETURNS TABLE (OperDateSP         TDateTime
             , InvNumberSP        TVarChar
             , PartnerMedicalId   Integer
             , PartnerMedicalName TVarChar             
             , MedicSPId          Integer
             , MedicSPName        TVarChar
             , MemberSPId         Integer
             , MemberSPName       TVarChar
             , GroupMemberSPId    Integer
             , GroupMemberSPName  TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    -- выбираем документы продажи по СП , (нужен последний)
    WITH tmpData AS (SELECT MovementDate_OperDateSP.ValueData            AS OperDateSP
                          , MovementString_InvNumberSP.ValueData         AS InvNumberSP
                          , MovementLinkObject_PartnerMedical.ObjectId   AS PartnerMedicalId
                          , Object_PartnerMedical.ValueData              AS PartnerMedicalName
                          , MovementLinkObject_MedicSP.ObjectId          AS MedicSPId
                          , Object_MedicSP.ValueData                     AS MedicSPName
                          , MovementLinkObject_MemberSP.ObjectId         AS MemberSPId
                          , Object_MemberSP.ValueData                    AS MemberSPName
                          , MovementLinkObject_GroupMemberSP.ObjectId    AS GroupMemberSPId
                          , Object_GroupMemberSP.ValueData               AS GroupMemberSPName
                           --  № п/п
                          , ROW_NUMBER() OVER (ORDER BY Movement_Sale.OperDate DESC, Movement_Sale.Id DESC) AS Ord
                     FROM Movement AS Movement_Sale
                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                  ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 AND MovementLinkObject_Unit.ObjectId = inUnitId

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                 ON MovementLinkObject_PartnerMedical.MovementId = Movement_Sale.Id
                                AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                          LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

                          LEFT JOIN MovementString AS MovementString_InvNumberSP
                                 ON MovementString_InvNumberSP.MovementId = Movement_Sale.Id
                                AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicSP
                                 ON MovementLinkObject_MedicSP.MovementId = Movement_Sale.Id
                                AND MovementLinkObject_MedicSP.DescId = zc_MovementLinkObject_MedicSP()
                          LEFT JOIN Object AS Object_MedicSP ON Object_MedicSP.Id = MovementLinkObject_MedicSP.ObjectId AND Object_MedicSP.DescId = zc_Object_MedicSP()

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                 ON MovementLinkObject_MemberSP.MovementId = Movement_Sale.Id
                                AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
                          LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId AND Object_MemberSP.DescId = zc_Object_MemberSP()
         
                          LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                 ON MovementDate_OperDateSP.MovementId = Movement_Sale.Id
                                AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_GroupMemberSP
                                 ON MovementLinkObject_GroupMemberSP.MovementId = Movement_Sale.Id
                                AND MovementLinkObject_GroupMemberSP.DescId = zc_MovementLinkObject_GroupMemberSP()
                          LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = MovementLinkObject_GroupMemberSP.ObjectId

                     WHERE Movement_Sale.DescId = zc_Movement_Sale()
                       AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                       AND Movement_Sale.OperDate >= CURRENT_DATE - INTERVAL '1 DAY'
                       AND ( COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) <> 0 OR
                             COALESCE (MovementLinkObject_GroupMemberSP.ObjectId ,0) <> 0 OR
                             COALESCE (MovementString_InvNumberSP.ValueData,'') <> '' OR
                             COALESCE (MovementLinkObject_MedicSP.ObjectId,0) <> 0 OR
                             COALESCE (MovementLinkObject_MemberSP.ObjectId,0) <> 0
                           )
                     ORDER BY Movement_Sale.Id DESC
                    )
                    
                    
                    
    -- Результат
    SELECT COALESCE (tmpData.OperDateSP, Null)       ::TDateTime AS OperDateSP
         , COALESCE (tmpData.InvNumberSP, '')        ::TVarChar  AS InvNumberSP
         , COALESCE (tmpData.PartnerMedicalId, 0)    ::Integer   AS PartnerMedicalId
         , COALESCE (tmpData.PartnerMedicalName, '') ::TVarChar  AS PartnerMedicalName
         , COALESCE (tmpData.MedicSPId, 0)           ::Integer   AS MedicSPId
         , COALESCE (tmpData.MedicSPName, '')        ::TVarChar  AS MedicSPName
         , COALESCE (tmpData.MemberSPId, 0)          ::Integer   AS MemberSPId
         , COALESCE (tmpData.MemberSPName, '')       ::TVarChar  AS MemberSPName
         , COALESCE (tmpData.GroupMemberSPId, 0)     ::Integer   AS GroupMemberSPId
         , COALESCE (tmpData.GroupMemberSPName, '')  ::TVarChar  AS GroupMemberSPName
    FROM (SELECT 1 AS xxx) AS tmp
         LEFT JOIN tmpData ON tmpData.Ord = 1
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 31.01.18         *
*/

-- тест
-- select * from gpGet_Movement_Sale_SP_Prior(inUnitId := 183289 ,  inSession := '3');