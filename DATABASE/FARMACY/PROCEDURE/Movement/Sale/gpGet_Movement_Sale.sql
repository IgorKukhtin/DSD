-- Function: gpGet_Movement_Sale()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , TotalSummPrimeCost TFloat
             , UnitId Integer
             , UnitName TVarChar
             , JuridicalId Integer
             , JuridicalName TVarChar
             , PaidKindId Integer
             , PaidKindName TVarChar
             , Comment TVarChar

             , OperDateSP TDateTime
             , PartnerMedicalId Integer
             , PartnerMedicalName TVarChar
             , InvNumberSP TVarChar
             , MedicSPId   Integer
             , MedicSPName TVarChar
             , MemberSPId   Integer
             , MemberSPName TVarChar
             , GroupMemberSPId Integer
             , GroupMemberSPName TVarChar
             , SPKindId   Integer
             , SPKindName TVarChar
             )
AS
$BODY$
   DECLARE vbUnitId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

    -- Для этих точек при создании накладной продажи  автоматом было прописано их подразделение, соотв. Мед.учреждение, Вид соцпроекта»- постановление 1303, «Форма оплаты» - БН.
    -- 1 - АП_2 ул_Бр.Трофимовых (Большая Диевская)_111 КЗДЦПМСП_5 (Шапиро ИА) (183289) и только с Комунальний заклад "ДЦПМСД №5" (3751525)
    -- 2 - Аптека_3 ул_Коммунаровская (Ю. Кондратюка)_1   (Шапиро ИА)          (183294) и только с Комунальний заклад "ДЦПМСД №5" (3751525)
    -- 3 - Аптека_2 шоссе_Донецкое_3 (АСНБ-4)                                  (377605) и только с Комунальний заклад "ДЦПМСД №11"(4212299)

    -- определяем подразделение ()
    vbUnitId := COALESCE ((SELECT tmp.UnitId FROM gpGet_UserUnit(inSession) AS tmp), 0);
    
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                AS Id
          , CAST (NEXTVAL ('movement_sale_seq') AS TVarChar) AS InvNumber
          , CURRENT_DATE::TDateTime                          AS OperDate
          , Object_Status.Code               	             AS StatusCode
          , Object_Status.Name              	             AS StatusName
          , 0::TFloat                                        AS TotalCount
          , 0::TFloat                                        AS TotalSumm
          , 0::TFloat                                        AS TotalSummPrimeCost
          , COALESCE (Object_Unit.Id, NULL)       ::Integer  AS UnitId
          , COALESCE (Object_Unit.ValueData, NULL)::TVarChar AS UnitName
          , NULL::Integer                                    AS JuridicalId
          , NULL::TVarChar                                   AS JuridicalName
          , COALESCE (Object_PaidKind.Id, NULL)        ::Integer  AS PaidKindId
          , COALESCE (Object_PaidKind.ValueData, NULL) ::TVarChar AS PaidKindName
          , NULL::TVarChar                                   AS Comment

          , CURRENT_DATE::TDateTime                          AS OperDateSP
          , COALESCE (Object_PartnerMedical.Id, NULL)        ::Integer   AS PartnerMedicalId
          , COALESCE (Object_PartnerMedical.ValueData, NULL) ::TVarChar  AS PartnerMedicalName
          , NULL::TVarChar                                   AS InvNumberSP
          , NULL::Integer                                    AS MedicSPId
          , NULL::TVarChar                                   AS MedicSPName
          , NULL::Integer                                    AS MemberSPId
          , NULL::TVarChar                                   AS MemberSPName

          , NULL::Integer                                    AS GroupMemberSPId
          , NULL::TVarChar                                   AS GroupMemberSPName

          , COALESCE (Object_SPKind.Id, NULL)        ::Integer   AS SPKindId
          , COALESCE (Object_SPKind.ValueData, NULL) ::TVarChar  AS SPKindName 

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = CASE WHEN vbUnitId IN (183289, 183294, 377605, 183292) THEN vbUnitId ELSE 0 END    --, 183292
            LEFT JOIN Object AS Object_SPKind   ON Object_SPKind.Id   = CASE WHEN vbUnitId IN (183289, 183294, 377605, 183292) THEN zc_Enum_SPKind_1303() ELSE 0 END
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = CASE WHEN vbUnitId IN (183289, 183294, 377605, 183292) THEN zc_Enum_PaidKind_FirstForm() ELSE 0 END
            LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = CASE WHEN vbUnitId IN (183289, 183294, 183292, 183292) THEN 3751525  --3690583 /*тест*/  --
                                                                                         WHEN vbUnitId = 377605 THEN 4212299
                                                                                         ELSE 0
                                                                                    END
        ;
    ELSE
        RETURN QUERY
        SELECT
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate
          , Movement_Sale.StatusCode
          , Movement_Sale.StatusName
          , Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.TotalSummPrimeCost
          , Movement_Sale.UnitId
          , Movement_Sale.UnitName
          , Movement_Sale.JuridicalId
          , Movement_Sale.JuridicalName
          , Movement_Sale.PaidKindId
          , Movement_Sale.PaidKindName
          , Movement_Sale.Comment

          , COALESCE(Movement_Sale.OperDateSP, Movement_Sale.OperDate) :: TDateTime AS OperDateSP
          , Movement_Sale.PartnerMedicalId
          , Movement_Sale.PartnerMedicalName
          , Movement_Sale.InvNumberSP
          , Movement_Sale.MedicSPid
          , Movement_Sale.MedicSPName
          , Movement_Sale.MemberSPId
          , Movement_Sale.MemberSPName

          , Movement_Sale.GroupMemberSPId
          , Movement_Sale.GroupMemberSPName

          , Movement_Sale.SPKindId
          , Movement_Sale.SPKindName 
        FROM
            Movement_Sale_View AS Movement_Sale
        WHERE Movement_Sale.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 08.02.17         * add SP
 15.09.16         *
 13.10.15                                                                        *
*/

--select * from gpGet_Movement_Sale(inMovementId := 0 , inOperDate := ('30.04.2017')::TDateTime ,  inSession := '3');

