-- Function: gpSelect_Movement_Cash()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, Boolean, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean   , --
    IN inKindName          TVarChar  , -- zc_Enum_InfoMoney_In or zc_Enum_InfoMoney_Out
    IN inCashId            Integer   ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_corr Integer
             , OperDate TDateTime, ServiceDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , isSign Boolean
             , Amount TFloat
             , MI_Id Integer
             , CashId Integer, CashCode Integer, CashName TVarChar, CashGroupNameFull TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, UnitGroupNameFull TVarChar, UnitNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , InfoMoneyDetailId Integer, InfoMoneyDetailCode Integer, InfoMoneyDetailName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , InsertName_mi TVarChar, InsertDate_mi TDateTime
             , UpdateName_mi TVarChar, UpdateDate_mi TDateTime
             , UserId_1 Integer, isSign_User1 Boolean, OperDate_User1 TDateTime
             , UserId_2 Integer, isSign_User2 Boolean, OperDate_User2 TDateTime
             , UserId_3 Integer, isSign_User3 Boolean, OperDate_User3 TDateTime
             , isChild Boolean, isChild_err Boolean
              )

AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUser_isAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

     -- ���������
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND Movement.DescId = zc_Movement_Cash()
                                                  AND Movement.StatusId = tmpStatus.StatusId
                          )

    , tmpData_all AS (SELECT tmpMovement.Id AS MovementId
                           , tmpMovement.InvNumber
                           , tmpMovement.OperDate
                           , tmpMovement.StatusId
                           , MovementItem.Id       AS MI_Id
                           , MovementItem.ObjectId AS ObjectId
                           , MovementItem.Amount   AS Amount
                           , MovementItem.DescId   AS MovementItemDescId
                      FROM tmpMovement
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                  AND MovementItem.DescId     IN (zc_MI_Master(), zc_MI_Child())
                                                  AND MovementItem.isErased   = FALSE
                                                  AND ((MovementItem.Amount <= 0 AND inKindName = 'zc_Enum_InfoMoney_Out')
                                                    OR (MovementItem.Amount >  0 AND inKindName = 'zc_Enum_InfoMoney_In')
                                                      )
                                                  AND (MovementItem.ObjectId = inCashId OR inCashId = 0)
                     )
        , tmpData AS (SELECT tmpData_all.MovementId
                           , tmpData_all.InvNumber
                           , tmpData_all.OperDate
                           , tmpData_all.StatusId
                           , tmpData_all.MI_Id
                           , tmpData_all.ObjectId
                           , tmpData_all.Amount
                      FROM tmpData_all
                      WHERE tmpData_all.MovementItemDescId = zc_MI_Master()
                     )
          --
        , tmpMI_Sign AS (SELECT tmp.MovementId
                              , MAX (CASE WHEN tmp.UserId = zfCalc_UserMain_1() AND tmp.isErased = FALSE THEN tmp.UserId   ELSE 0  END) AS UserId_1
                              , MAX (CASE WHEN tmp.UserId = zfCalc_UserMain_2() AND tmp.isErased = FALSE THEN tmp.UserId   ELSE 0  END) AS UserId_2
                              , MAX (CASE WHEN tmp.UserId = zfCalc_UserMain_3() AND tmp.isErased = FALSE THEN tmp.UserId   ELSE 0  END) AS UserId_3

                              , MAX (CASE WHEN tmp.UserId = zfCalc_UserMain_1() THEN tmp.MovementItemId   ELSE 0  END) AS Id_mi_1
                              , MAX (CASE WHEN tmp.UserId = zfCalc_UserMain_2() THEN tmp.MovementItemId   ELSE 0  END) AS Id_mi_2
                              , MAX (CASE WHEN tmp.UserId = zfCalc_UserMain_3() THEN tmp.MovementItemId   ELSE 0  END) AS Id_mi_3
                         FROM (SELECT MovementItem.MovementId AS MovementId
                                    , MovementItem.Id         AS MovementItemId
                                    , MovementItem.ObjectId   AS UserId
                                    , MovementItem.isErased   AS isErased
                               FROM (SELECT DISTINCT tmpData.MovementId FROM tmpData) AS tmp
                                    INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                                           AND MovementItem.DescId     = zc_MI_Sign()
                              ) AS tmp
                         GROUP BY tmp.MovementId
                        )
       -- ���������
       SELECT
             tmpData.MovementId                   AS Id
           , zfConvert_StringToNumber(tmpData.InvNumber) AS InvNumber
           , CASE WHEN MovementBoolean_Sign.ValueData IS NOT NULL THEN zfConvert_StringToNumber (tmpData.InvNumber) ELSE 0 END :: Integer InvNumber_corr
           , tmpData.OperDate                     AS OperDate
           , CASE WHEN ObjectBoolean_Service.ValueData = TRUE THEN MIDate_ServiceDate.ValueData ELSE NULL END :: TDateTime AS ServiceDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , COALESCE (MovementBoolean_Sign.ValueData, FALSE) :: Boolean AS isSign
           --, COALESCE (MIBoolean_Child.ValueData, FALSE)      :: Boolean AS isChild

           , CASE WHEN tmpData.Amount < 0 THEN tmpData.Amount * (-1) ELSE tmpData.Amount END  ::TFloat AS Amount
           , tmpData.MI_Id                      AS MI_Id
           , Object_Cash.Id                     AS CashId
           , Object_Cash.ObjectCode             AS CashCode
           , Object_Cash.ValueData              AS CashName
           , ObjectString_Cash_GroupNameFull.ValueData AS CashGroupNameFull
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ObjectCode             AS UnitCode
           , Object_Unit.ValueData              AS UnitName
           , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull
           , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitNameFull
           , Object_InfoMoney.Id                AS InfoMoneyId
           , Object_InfoMoney.ObjectCode        AS InfoMoneyCode
           , Object_InfoMoney.ValueData         AS InfoMoneyName
           , Object_InfoMoneyDetail.Id          AS InfoMoneyDetailId
           , Object_InfoMoneyDetail.ObjectCode  AS InfoMoneyDetailCode
           , Object_InfoMoneyDetail.ValueData   AS InfoMoneyDetailName
           , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
           , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

           , Object_Insert.ValueData            AS InsertName
           , MovementDate_Insert.ValueData      AS InsertDate
           , Object_Update.ValueData            AS UpdateName
           , MovementDate_Update.ValueData      AS UpdateDate

           , Object_Insert_mi.ValueData         AS InsertName_mi
           , MIDate_Insert_mi.ValueData         AS InsertDate_mi
           , Object_Update_mi.ValueData         AS UpdateName_mi
           , MIDate_Update_mi.ValueData         AS UpdateDate_mi

           , tmpMI_Sign.UserId_1   ::Integer
           , CASE WHEN tmpMI_Sign.UserId_1 > 0 THEN TRUE ELSE FALSE END ::Boolean
           , MID_Sign_User1.ValueData
           , tmpMI_Sign.UserId_2   ::Integer
           , CASE WHEN tmpMI_Sign.UserId_2 > 0 THEN TRUE ELSE FALSE END ::Boolean
           , MID_Sign_User2.ValueData
           , tmpMI_Sign.UserId_3   ::Integer
           , CASE WHEN tmpMI_Sign.UserId_3 > 0 THEN TRUE ELSE FALSE END ::Boolean
           , MID_Sign_User3.ValueData

           , CASE WHEN tmpData_Child.MovementId > 0 AND COALESCE (MovementBoolean_Sign.ValueData, FALSE) = FALSE
                       THEN TRUE
                       ELSE FALSE
             END :: Boolean AS isChild

           , CASE WHEN tmpData_Child.MovementId > 0 AND tmpData.Amount <> tmpData_Child.Amount AND COALESCE (MovementBoolean_Sign.ValueData, FALSE) = FALSE
                       THEN TRUE
                       ELSE FALSE
             END :: Boolean AS isChild_err

       FROM tmpData
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId

            LEFT JOIN (SELECT tmpData_all.MovementId, SUM (tmpData_all.Amount) AS Amount FROM tmpData_all WHERE tmpData_all.MovementItemDescId = zc_MI_Child()
                       GROUP BY tmpData_all.MovementId
                      ) AS tmpData_Child
                        ON tmpData_Child.MovementId = tmpData.MovementId


            LEFT JOIN MovementBoolean AS MovementBoolean_Sign
                                      ON MovementBoolean_Sign.MovementId = tmpData.MovementId
                                     AND MovementBoolean_Sign.DescId = zc_MovementBoolean_Sign()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = tmpData.MovementId
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = tmpData.MovementId
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = tmpData.MovementId
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = tmpData.MovementId
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId
            --

            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = tmpData.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = tmpData.MI_Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                   ON ObjectString_Unit_GroupNameFull.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = tmpData.MI_Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoneyDetail
                                             ON MILinkObject_InfoMoneyDetail.MovementItemId = tmpData.MI_Id
                                            AND MILinkObject_InfoMoneyDetail.DescId = zc_MILinkObject_InfoMoneyDetail()
            LEFT JOIN Object AS Object_InfoMoneyDetail ON Object_InfoMoneyDetail.Id = MILinkObject_InfoMoneyDetail.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                             ON MILinkObject_CommentInfoMoney.MovementItemId = tmpData.MI_Id
                                            AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = tmpData.MI_Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

            LEFT JOIN MovementItemDate AS MIDate_Insert_mi
                                       ON MIDate_Insert_mi.MovementItemId = tmpData.MI_Id
                                      AND MIDate_Insert_mi.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_Update_mi
                                       ON MIDate_Update_mi.MovementItemId = tmpData.MI_Id
                                      AND MIDate_Update_mi.DescId = zc_MIDate_Update()

            LEFT JOIN MovementItemLinkObject AS MILO_Insert_mi
                                             ON MILO_Insert_mi.MovementItemId = tmpData.MI_Id
                                            AND MILO_Insert_mi.DescId = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert_mi ON Object_Insert_mi.Id = MILO_Insert_mi.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_Update_mi
                                             ON MILO_Update_mi.MovementItemId = tmpData.MI_Id
                                            AND MILO_Update_mi.DescId = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update_mi ON Object_Update_mi.Id = MILO_Update_mi.ObjectId


            LEFT JOIN tmpMI_Sign ON tmpMI_Sign.MovementId = tmpData.MovementId

            LEFT JOIN MovementItemDate AS MID_Sign_User1
                                       ON MID_Sign_User1.MovementItemId = tmpMI_Sign.Id_mi_1
                                      AND MID_Sign_User1.DescId         = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MID_Sign_User2
                                       ON MID_Sign_User2.MovementItemId = tmpMI_Sign.Id_mi_2
                                      AND MID_Sign_User2.DescId         = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MID_Sign_User3
                                       ON MID_Sign_User3.MovementItemId = tmpMI_Sign.Id_mi_3
                                      AND MID_Sign_User3.DescId         = zc_MIDate_Insert()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Service
                                    ON ObjectBoolean_Service.ObjectId = Object_InfoMoney.Id
                                   AND ObjectBoolean_Service.DescId = zc_ObjectBoolean_InfoMoney_Service()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                    ON ObjectBoolean_UserAll.ObjectId = Object_Cash.Id
                                   AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_Cash_UserAll()

            LEFT JOIN ObjectString AS ObjectString_Cash_GroupNameFull
                                   ON ObjectString_Cash_GroupNameFull.ObjectId = Object_Cash.Id
                                  AND ObjectString_Cash_GroupNameFull.DescId = zc_ObjectString_Cash_GroupNameFull()

        WHERE vbUser_isAll = TRUE OR ObjectBoolean_UserAll.ValueData = TRUE OR ObjectBoolean_Service.ValueData = TRUE
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.05.2          *
 15.01.22         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Cash(inStartDate := ('01.01.2023')::TDateTime , inEndDate := ('01.10.2023')::TDateTime , inIsErased := 'False' , inKindName := 'zc_Enum_InfoMoney_In', inCashId:= 0, inSession := '5');
