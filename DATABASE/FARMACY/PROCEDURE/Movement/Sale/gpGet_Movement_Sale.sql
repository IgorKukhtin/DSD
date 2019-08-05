-- Function: gpGet_Movement_Sale()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
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
             , Address_MemberSP TVarChar
             , INN_MemberSP TVarChar
             , Passport_MemberSP TVarChar
             , GroupMemberSPId Integer
             , GroupMemberSPName TVarChar
             , SPKindId   Integer
             , SPKindName TVarChar
             , isDeferred Boolean
             )
AS
$BODY$
   DECLARE vbUnitId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

    -- ��� ���� ����� ��� �������� ��������� �������  ��������� ���� ��������� �� �������������, �����. ���.����������, ��� ����������- ������������� 1303, ������ ������� - ��.
    -- 1 - ��_2 ��_��.���������� (������� ��������)_111 ��������_5 (������ ��) (183289) � ������ � ����������� ������ "������ �5" (3751525)
    -- 2 - ������_3 ��_�������������� (�. ����������)_1   (������ ��)          (183294) � ������ � ����������� ������ "������ �5" (3751525)
    -- 3 - ������_2 �����_��������_3 (����-4)                                  (377605) � ������ � ����������� ������ "������ �11"(4212299)

    -- ���������� ������������� ()
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

          , (CURRENT_DATE + interval '1 day')                ::TDateTime AS OperDateSP
          , COALESCE (Object_PartnerMedical.Id, NULL)        ::Integer   AS PartnerMedicalId
          , COALESCE (Object_PartnerMedical.ValueData, NULL) ::TVarChar  AS PartnerMedicalName
          , NULL::TVarChar                                   AS InvNumberSP
          , NULL::Integer                                    AS MedicSPId
          , NULL::TVarChar                                   AS MedicSPName
          , NULL::Integer                                    AS MemberSPId
          , NULL::TVarChar                                   AS MemberSPName
          , NULL  :: TVarChar                                AS Address_MemberSP
          , NULL  :: TVarChar                                AS INN_MemberSP
          , NULL  :: TVarChar                                AS Passport_MemberSP

          , NULL::Integer                                    AS GroupMemberSPId
          , NULL::TVarChar                                   AS GroupMemberSPName

          , COALESCE (Object_SPKind.Id, NULL)        ::Integer   AS SPKindId
          , COALESCE (Object_SPKind.ValueData, NULL) ::TVarChar  AS SPKindName 
          , FALSE::Boolean                                       AS isDeferred

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = vbUnitId
            
            LEFT JOIN ObjectLink AS ObjectLink_Unit_PartnerMedical
                                 ON ObjectLink_Unit_PartnerMedical.ObjectId = Object_Unit.Id 
                                AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()
            LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_Unit_PartnerMedical.ChildObjectId

            LEFT JOIN Object AS Object_SPKind   ON Object_SPKind.Id   = zc_Enum_SPKind_1303()        AND COALESCE (Object_PartnerMedical.Id, 0) <> 0
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm() AND COALESCE (Object_PartnerMedical.Id, 0) <> 0

          /*LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = CASE WHEN vbUnitId IN (183289, 183294, 377605) THEN vbUnitId ELSE 0 END    --, 183292
            LEFT JOIN Object AS Object_SPKind   ON Object_SPKind.Id   = CASE WHEN vbUnitId IN (183289, 183294, 377605) THEN zc_Enum_SPKind_1303() ELSE 0 END
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = CASE WHEN vbUnitId IN (183289, 183294, 377605) THEN zc_Enum_PaidKind_FirstForm() ELSE 0 END
            LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = CASE WHEN vbUnitId IN (183289, 183294) THEN 3751525  --3690583 /*����*/  --
                                                                                         WHEN vbUnitId = 377605 THEN 4212299
                                                                                         ELSE 0
                                                                                    END*/
        
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

          , COALESCE(Movement_Sale.OperDateSP, Movement_Sale.OperDate + interval '1 day' ) :: TDateTime AS OperDateSP
          , Movement_Sale.PartnerMedicalId
          , Movement_Sale.PartnerMedicalName
          , Movement_Sale.InvNumberSP
          , Movement_Sale.MedicSPid
          , Movement_Sale.MedicSPName
          , Movement_Sale.MemberSPId
          , Movement_Sale.MemberSPName

          , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address_MemberSP
          , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN_MemberSP
          , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport_MemberSP

          , Movement_Sale.GroupMemberSPId
          , Movement_Sale.GroupMemberSPName

          , Movement_Sale.SPKindId
          , Movement_Sale.SPKindName 
          , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean  AS isDeferred
          
        FROM Movement_Sale_View AS Movement_Sale

         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Movement_Sale.MemberSPId
                               AND ObjectString_Address.DescId = zc_ObjectString_MemberSP_Address()
         LEFT JOIN ObjectString AS ObjectString_INN
                                ON ObjectString_INN.ObjectId = Movement_Sale.MemberSPId
                               AND ObjectString_INN.DescId = zc_ObjectString_MemberSP_INN()
         LEFT JOIN ObjectString AS ObjectString_Passport
                                ON ObjectString_Passport.ObjectId = Movement_Sale.MemberSPId
                               AND ObjectString_Passport.DescId = zc_ObjectString_MemberSP_Passport()
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement_Sale.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
        WHERE Movement_Sale.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������ �.�.
 31.07.19                                                                                     *
 15.01.19         *
 05.06.18         *
 08.02.17         * add SP
 15.09.16         *
 13.10.15                                                                        *
*/

--select * from gpGet_Movement_Sale(inMovementId := 0 , inOperDate := ('30.04.2017')::TDateTime ,  inSession := '3');

