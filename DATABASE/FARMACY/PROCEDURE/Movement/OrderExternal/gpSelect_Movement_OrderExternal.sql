-- Function: gpSelect_Movement_OrderExternal_Ol()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternal(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat, TotaSummWithNDS TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar, JuridicalName TVarChar, ProvinceCityName TVarChar
             , ContractId Integer, ContractName TVarChar
             , MasterId Integer, MasterInvNumber TVarChar, OrderKindName TVarChar
             , Comment TVarChar
             , UpdateName TVarChar, UpdateDate TDateTime

             , isZakazToday       Boolean
             , isDostavkaToday    Boolean
             , isDeferred         Boolean
             , isDifferent        Boolean
             , OperDate_Zakaz     TVarChar
             , OperDate_Dostavka  TVarChar
             , Zakaz_Text         TVarChar
             , Dostavka_Text      TVarChar
             , LetterSubject      TVarChar
             , isUseSubject       Boolean
             , isSupplierFailures Boolean
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbCURRENT_DOW Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ <�������� ����>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     vbCURRENT_DOW := CASE WHEN EXTRACT (DOW FROM CURRENT_DATE) = 0 THEN 7 ELSE EXTRACT (DOW FROM CURRENT_DATE) END ; -- ���� ������ �������

      -- raise notice'ObjectProtocol 1: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpMovement_OrderExternalAll ON COMMIT DROP AS
     WITH
        tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                      UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                      UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                      )
      SELECT Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Movement.StatusId                                  AS StatusId
           , MovementLinkObject_To.ObjectId                     AS ToId
       FROM Movement
                                                             
            INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId 
                                                             
            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                           
       WHERE Movement.DescId = zc_Movement_OrderExternal()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
                                         
     ANALYSE tmpMovement_OrderExternalAll;
                                         
      -- raise notice'ObjectProtocol 2: %', CLOCK_TIMESTAMP();
           
     CREATE TEMP TABLE tmpMovement_OrderExternal ON COMMIT DROP AS
     WITH
        tmpUnit  AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                     FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                             AND (ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId OR vbUserId = zfCalc_UserAdmin() :: Integer)
                     WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     )

      SELECT Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Movement.StatusId                                  AS StatusId
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementLinkObject_From.ObjectId                   AS FromId
           , Object_From.ObjectCode                             AS FromCode
           , Object_From.ValueData                              AS FromName
           , Movement.ToId                                      AS ToId
           , Object_To.Code                                     AS ToCode
           , Object_To.Name                                     AS ToName
           , Object_To.JuridicalId                              AS JuridicalId
           , Object_To.JuridicalCode                            AS JuridicalCode
           , Object_To.JuridicalName                            AS JuridicalName
           , MovementLinkObject_Contract.ObjectId               AS ContractId
           , Object_Contract.ValueData                          AS ContractName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSum
           , Movement_Master.Id                                 AS MasterId
           , ('� '||Movement_Master.InvNumber || ' �� '|| TO_CHAR(Movement_Master.Operdate , 'DD.MM.YYYY')) :: TVarChar   AS MasterInvNumber 
           , COALESCE(MovementString_Comment.ValueData,'')        :: TVarChar AS Comment
           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) :: Boolean  AS isDeferred          

       FROM tmpMovement_OrderExternalAll AS Movement
                                         
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                                                          
            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            INNER JOIN tmpUnit ON tmpUnit.UnitId = Movement.ToId

            LEFT JOIN Object_Unit_View AS Object_To ON Object_To.Id = Movement.ToId
                                                  
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkMovement AS MLM_Master
                                           ON MLM_Master.MovementId = Movement.Id
                                          AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MLM_Master.MovementChildId
            
       ;
                                         
     ANALYSE tmpMovement_OrderExternal;
                                         
      -- raise notice'ObjectProtocol 21: %', CLOCK_TIMESTAMP();
     
     
     CREATE TEMP TABLE tmpOrderShedule ON COMMIT DROP AS
      SELECT ObjectLink_OrderShedule_Unit.ChildObjectId              AS UnitId  --To 
           , ObjectLink_OrderShedule_Contract.ChildObjectId          AS ContractId --
           , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1)) ::TFloat AS Value1
           , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2)) ::TFloat AS Value2
           , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3)) ::TFloat AS Value3
           , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4)) ::TFloat AS Value4
           , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5)) ::TFloat AS Value5
           , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6)) ::TFloat AS Value6
           , ('0'||zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7)) ::TFloat AS Value7
           , Object_OrderShedule.ValueData AS Value8

      FROM Object AS Object_OrderShedule
           LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                  ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                 AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
           LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                  ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                 AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
      WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule()
        AND Object_OrderShedule.isErased = FALSE;
                           
     
     ANALYSE tmpOrderShedule;
                                         
      -- raise notice'ObjectProtocol 3: %', CLOCK_TIMESTAMP();
                                         
      
     RETURN QUERY
     WITH 
     --������ ����������� ������ ������/��������
          tmpDateList AS (SELECT ''||tmp.OperDate :: Date || ' (' ||tmpDayOfWeek.DayOfWeekName ||')' AS OperDate
                               , tmpDayOfWeek.Number
                               , tmpDayOfWeek.DayOfWeekName
                          FROM (SELECT generate_series ( CURRENT_DATE,  CURRENT_DATE+interval '6 day', '1 day' :: INTERVAL) AS OperDate) AS tmp
                            LEFT JOIN zfCalc_DayOfWeekName(tmp.OperDate) AS tmpDayOfWeek ON 1=1
                          )
      , tmpOrderSheduleText AS (SELECT tmpOrderShedule.UnitId
                                     , tmpOrderShedule.ContractId
                                     , (CASE WHEN tmpOrderShedule.Value1 in (1,3) THEN '�����������,' ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value2 in (1,3) THEN '�������,'     ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value3 in (1,3) THEN '�����,'       ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value4 in (1,3) THEN '�������,'     ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value5 in (1,3) THEN '�������,'     ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value6 in (1,3) THEN '�������,'     ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value7 in (1,3) THEN '�����������'  ELSE '' END) ::TVarChar          AS Zakaz_Text   --���� ������ (������������)
                                     , (CASE WHEN tmpOrderShedule.Value1 in (2,3) THEN '�����������,' ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value2 in (2,3) THEN '�������,'     ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value3 in (2,3) THEN '�����,'       ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value4 in (2,3) THEN '�������,'     ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value5 in (2,3) THEN '�������,'     ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value6 in (2,3) THEN '�������,'     ELSE '' END ||
                                        CASE WHEN tmpOrderShedule.Value7 in (2,3) THEN '�����������'  ELSE '' END) ::TVarChar          AS Dostavka_Text   --���� �������� (������������)
                                FROM tmpOrderShedule
                                )

      , tmpOrderSheduleList AS (SELECT tmp.*
                                FROM (
                                      select tmpOrderShedule.UnitId, tmpOrderShedule.ContractId, CASE WHEN Value1 in (1,3) THEN 1 ELSE 0 END AS DoW, CASE WHEN Value1 in (2,3) THEN 1 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.UnitId, tmpOrderShedule.ContractId, CASE WHEN Value2 in (1,3) THEN 2 ELSE 0 END AS DoW, CASE WHEN Value2 in (2,3) THEN 2 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.UnitId, tmpOrderShedule.ContractId, CASE WHEN Value3 in (1,3) THEN 3 ELSE 0 END AS DoW, CASE WHEN Value3 in (2,3) THEN 3 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.UnitId, tmpOrderShedule.ContractId, CASE WHEN Value4 in (1,3) THEN 4 ELSE 0 END AS DoW, CASE WHEN Value4 in (2,3) THEN 4 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.UnitId, tmpOrderShedule.ContractId, CASE WHEN Value5 in (1,3) THEN 5 ELSE 0 END AS DoW, CASE WHEN Value5 in (2,3) THEN 5 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.UnitId, tmpOrderShedule.ContractId, CASE WHEN Value6 in (1,3) THEN 6 ELSE 0 END AS DoW, CASE WHEN Value6 in (2,3) THEN 6 ELSE 0 END AS DoW_D from tmpOrderShedule
                                      union select tmpOrderShedule.UnitId, tmpOrderShedule.ContractId, CASE WHEN Value7 in (1,3) THEN 7 ELSE 0 END AS DoW, CASE WHEN Value7 in (2,3) THEN 7 ELSE 0 END AS DoW_D from tmpOrderShedule) AS tmp
                                WHERE tmp.DoW <> 0 OR tmp.DoW_D <> 0
                                )
      , tmpAfter AS (SELECT tmp.UnitId, tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                     FROM ( 
                           SELECT tmpOrderSheduleList.UnitId, tmpOrderSheduleList.ContractId, min (DoW) AS DoW, 0 AS DoW_D
                           FROM tmpOrderSheduleList
                           WHERE tmpOrderSheduleList.DoW > vbCURRENT_DOW
                             AND tmpOrderSheduleList.DoW > 0
                           GROUP BY tmpOrderSheduleList.UnitId, tmpOrderSheduleList.ContractId
                           Union
                           SELECT tmpOrderSheduleList.UnitId, tmpOrderSheduleList.ContractId, 0 AS DoW, min (DoW_D) AS DoW_D
                           FROM tmpOrderSheduleList
                           WHERE tmpOrderSheduleList.DoW_D > vbCURRENT_DOW
                             AND tmpOrderSheduleList.DoW_D > 0
                           GROUP BY tmpOrderSheduleList.UnitId, tmpOrderSheduleList.ContractId) as tmp
                     GROUP BY tmp.UnitId, tmp.ContractId
                     )
      , tmpBefore AS (SELECT tmp.UnitId, tmp.ContractId, max (DoW) AS DoW, max (DoW_D) AS DoW_D
                      FROM (
                          SELECT tmpOrderSheduleList.UnitId, tmpOrderSheduleList.ContractId,  min (tmpOrderSheduleList.DoW) AS DoW, 0 AS DoW_D
                          FROM tmpOrderSheduleList
                             LEFT JOIN tmpAfter ON tmpAfter.UnitId = tmpOrderSheduleList.UnitId
                                               AND tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                          WHERE tmpOrderSheduleList.DoW < vbCURRENT_DOW
                            AND tmpAfter.UnitId IS NULL
                              AND tmpOrderSheduleList.DoW<>0
                          GROUP BY tmpOrderSheduleList.UnitId, tmpOrderSheduleList.ContractId
                      UNION 
                          SELECT tmpOrderSheduleList.UnitId, tmpOrderSheduleList.ContractId, 0 AS DoW,  min (tmpOrderSheduleList.DoW_D) AS DoW_D
                          FROM tmpOrderSheduleList
                             LEFT JOIN tmpAfter ON tmpAfter.UnitId = tmpOrderSheduleList.UnitId
                                               AND tmpAfter.ContractId = tmpOrderSheduleList.ContractId
                          WHERE tmpOrderSheduleList.DoW_D < vbCURRENT_DOW
                            AND tmpAfter.UnitId IS NULL
                              AND tmpOrderSheduleList.DoW_D<>0
                          GROUP BY tmpOrderSheduleList.UnitId, tmpOrderSheduleList.ContractId) as tmp
                      GROUP BY tmp.UnitId, tmp.ContractId
                      )
      , OrderSheduleList AS ( SELECT tmp.UnitId, tmp.ContractId
                                   , tmpDateList.OperDate         AS OperDate_Zakaz
                                   , tmpDateList_D.OperDate       AS OperDate_Dostavka
                              FROM (SELECT *
                                    FROM tmpAfter
                                 union all 
                                    SELECT *
                                    FROM tmpBefore
                                   ) AS tmp
                               LEFT JOIN tmpDateList ON tmpDateList.Number = tmp.DoW
                               LEFT JOIN tmpDateList AS tmpDateList_D ON tmpDateList_D.Number = tmp.DoW_D
                         )
      , OrderSheduleListToday AS (SELECT *
                                  FROM tmpOrderSheduleList
                                  WHERE tmpOrderSheduleList.DoW = vbCURRENT_DOW OR tmpOrderSheduleList.DoW_D = vbCURRENT_DOW 
                                 )
--

       SELECT
             Movement_OrderExternal_View.Id
           , Movement_OrderExternal_View.InvNumber
           , Movement_OrderExternal_View.OperDate
           , Movement_OrderExternal_View.StatusCode
           , Movement_OrderExternal_View.StatusName
           , Movement_OrderExternal_View.TotalCount
           , Movement_OrderExternal_View.TotalSum
           , MovementFloat_TotalSummPVAT.ValueData      AS TotaSummWithNDS
           , Movement_OrderExternal_View.FromId
           , Movement_OrderExternal_View.FromName
           , Movement_OrderExternal_View.ToId
           , Movement_OrderExternal_View.ToName
           , Movement_OrderExternal_View.JuridicalName
           , Object_ProvinceCity.ValueData              AS ProvinceCityName
           , Movement_OrderExternal_View.ContractId
           , Movement_OrderExternal_View.ContractName
           , Movement_OrderExternal_View.MasterId
           , Movement_OrderExternal_View.MasterInvNumber
           , Object_OrderKind.ValueData                 AS OrderKindName
           , Movement_OrderExternal_View.Comment

           , Object_Update.ValueData                    AS UpdateName
           , MovementDate_Update.ValueData              AS UpdateDate

           , CASE WHEN COALESCE(OrderSheduleListToday.DOW,  0) = 0 THEN False ELSE TRUE END AS isZakazToday
           , CASE WHEN COALESCE(OrderSheduleListToday.DoW_D,0) = 0 THEN False ELSE TRUE END AS isDostavkaToday

           , Movement_OrderExternal_View.isDeferred
           , COALESCE (MovementBoolean_Different.ValueData, FALSE) :: Boolean  AS isDifferent

           , OrderSheduleList.OperDate_Zakaz    ::TVarChar
           , OrderSheduleList.OperDate_Dostavka ::TVarChar

           , tmpOrderSheduleText.Zakaz_Text
           , tmpOrderSheduleText.Dostavka_Text
           , MovementString_LetterSubject.ValueData                            AS LetterSubject
           , COALESCE (MovementBoolean_UseSubject.ValueData, FALSE) :: Boolean AS isUseSubject
           , COALESCE (MovementBoolean_SupplierFailures.ValueData, FALSE) :: Boolean AS isSupplierFailures
     FROM tmpMovement_OrderExternal AS Movement_OrderExternal_View 

          LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderKind
                                       ON MovementLinkObject_OrderKind.MovementId = Movement_OrderExternal_View.MasterId
                                      AND MovementLinkObject_OrderKind.DescId = zc_MovementLinkObject_OrderKind()
          LEFT JOIN Object AS Object_OrderKind ON Object_OrderKind.Id = MovementLinkObject_OrderKind.ObjectId

          LEFT JOIN MovementDate AS MovementDate_Update
                                 ON MovementDate_Update.MovementId = Movement_OrderExternal_View.Id
                                AND MovementDate_Update.DescId = zc_MovementDate_Update()
          LEFT JOIN MovementLinkObject AS MLO_Update
                                       ON MLO_Update.MovementId = Movement_OrderExternal_View.Id
                                      AND MLO_Update.DescId = zc_MovementLinkObject_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId  

          LEFT JOIN OrderSheduleList ON OrderSheduleList.UnitId     = Movement_OrderExternal_View.ToId
                                    AND OrderSheduleList.ContractId = Movement_OrderExternal_View.ContractId
          LEFT JOIN OrderSheduleListToday ON OrderSheduleListToday.UnitId    = Movement_OrderExternal_View.ToId
                                         AND OrderSheduleListToday.ContractId = Movement_OrderExternal_View.ContractId
          LEFT JOIN tmpOrderSheduleText ON tmpOrderSheduleText.UnitId     = Movement_OrderExternal_View.ToId
                                       AND tmpOrderSheduleText.ContractId = Movement_OrderExternal_View.ContractId

          -- ����� ������� ��.����
          LEFT JOIN MovementBoolean AS MovementBoolean_Different
                                    ON MovementBoolean_Different.MovementId = Movement_OrderExternal_View.Id
                                   AND MovementBoolean_Different.DescId = zc_MovementBoolean_Different()

          LEFT JOIN MovementBoolean AS MovementBoolean_SupplierFailures
                                    ON MovementBoolean_SupplierFailures.MovementId = Movement_OrderExternal_View.Id
                                   AND MovementBoolean_SupplierFailures.DescId = zc_MovementBoolean_SupplierFailures()

          LEFT JOIN MovementString AS MovementString_LetterSubject
                                   ON MovementString_LetterSubject.MovementId = Movement_OrderExternal_View.Id
                                  AND MovementString_LetterSubject.DescId = zc_MovementString_LetterSubject()

          LEFT JOIN MovementBoolean AS MovementBoolean_UseSubject
                                    ON MovementBoolean_UseSubject.MovementId = Movement_OrderExternal_View.Id
                                   AND MovementBoolean_UseSubject.DescId = zc_MovementBoolean_UseSubject()

          LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                  ON MovementFloat_TotalSummPVAT.MovementId = Movement_OrderExternal_View.Id
                                 AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                                 
          LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                               ON ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                              AND ObjectLink_Unit_ProvinceCity.ObjectId = Movement_OrderExternal_View.ToId
          LEFT JOIN Object AS Object_ProvinceCity 
                           ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
    ;

      -- raise notice'ObjectProtocol 20: %', CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_OrderExternal (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.12.16         * isDeferred
 10.05.16         *
 15.07.14                                                        *
 01.07.14                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_OrderExternal (inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= '2')

--select * from gpSelect_Movement_OrderExternal(instartdate := ('27.12.2016')::TDateTime , inenddate := ('27.12.2016')::TDateTime , inIsErased := 'False' ,  inSession := '3');


select * from gpSelect_Movement_OrderExternal(instartdate := ('01.08.2023')::TDateTime , inenddate := ('31.08.2023')::TDateTime , inIsErased := 'False' ,  inSession := '3');