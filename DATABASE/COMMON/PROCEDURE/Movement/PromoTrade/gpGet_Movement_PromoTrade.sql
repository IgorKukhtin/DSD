-- Function: gpGet_Movement_PromoTrade()

DROP FUNCTION IF EXISTS gpGet_Movement_PromoTrade (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PromoTrade(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inMask              Boolean  , -- �������� �� �����
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id               Integer     --�������������
             , InvNumber        Integer    --����� ���������
             , InvNumberFull    TVarChar   --����� ��������� + ����
             , OperDate         TDateTime   --���� ���������
             , StatusCode       Integer     --��� �������
             , StatusName       TVarChar    --������
             , ContractId       Integer     --��������
             , ContractName     TVarChar    --�������� 
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractTagId Integer, ContractTagName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , RetailId Integer, RetailName TVarChar
             , PromoKindId      Integer     --��� �����
             , PromoKindName    TVarChar    --��� �����
             , PromoItemId      Integer     -- ������ ������
             , PromoItemName    TVarChar  -- ������ ������
             , PriceListId      Integer     --����� ����
             , PriceListName    TVarChar    --����� ����
             , StartPromo       TDateTime   --���� ������ �����
             , EndPromo         TDateTime   --���� ��������� �����
             , OperDateStart    TDateTime   --���� ������ ����. ������ �� �����
             , OperDateEnd      TDateTime   --���� ��������� ����. ������ �� �����
             , CostPromo        TFloat      --��������� ������� � �����
             , ChangePercent    TFloat      --(-)% ������ (+)% ������� �� ��������

             , Comment          TVarChar    --����������
             , PersonalTradeId  INTEGER     --������������� ������������� ������������� ������
             , PersonalTradeName TVarChar   --������������� ������������� ������������� ������

             , SignInternalId   Integer
             , SignInternalName TVarChar
             , PromoTradeStateKindId Integer     -- ��������� �����
             , PromoTradeStateKindName TVarChar  -- ��������� �����
             , CheckDate        TDateTime   -- ���� ������������  
             , isPromoStateKind   Boolean   -- ��������� ��� ���������

             , strSign        TVarChar -- ��� �������������. - ���� ��. �������
             , strSignNo      TVarChar -- ��� �������������. - ��������� ��. �������

             , InsertDate TDateTime
             , InsertName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbSignInternalId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    --IF NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
     -- ������� ��� �� �����
     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_PromoTrade_Mask (ioId        := inMovementId
                                                      , inOperDate  := inOperDate
                                                      , inSession   := inSession);
     END IF;

    IF COALESCE (inMovementId, 0) < 0
    THEN
        RAISE EXCEPTION '������. ���������� ������� ������ ��������.';
    END IF;


    IF COALESCE (inMovementId, 0) = 0
    THEN
        -- ������ �� ������ ��� ������� ���������
        vbSignInternalId := (SELECT DISTINCT tmp.SignInternalId
                             FROM lpSelect_Object_SignInternalItem ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_SignInternal())
                                                                  , (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId)
                                                                  , 0, 0) AS tmp
                            );

        -- ���������
        RETURN QUERY
        SELECT
            0                                                 AS Id
          , CAST (NEXTVAL ('movement_PromoTrade_seq') AS Integer)  AS InvNumber
          , ''  :: TVarChar                                   AS InvNumberFull
          , inOperDate	                                      AS OperDate
          , Object_Status.Code               	              AS StatusCode
          , Object_Status.Name              		          AS StatusName
          , NULL ::Integer                                    AS ContractId
          , NULL ::TVarChar                                   AS ContractName  
          , NULL ::Integer                                    AS PaidKindId
          , NULL ::TVarChar                                   AS PaidKindName
          , NULL ::Integer                                    AS ContractTagId
          , NULL ::TVarChar                                   AS ContractTagName
          , NULL ::Integer                                    AS JuridicalId
          , NULL ::TVarChar                                   AS JuridicalName
          , NULL ::Integer                                    AS RetailId
          , NULL ::TVarChar                                   AS RetailNam�
          , NULL::Integer                                     AS PromoKindId         --��� �����
          , NULL::TVarChar                                    AS PromoKindName       --��� �����
          , 0                                                 AS PromoItemId        --
          , NULL::TVarChar                                    AS PromoItemName      --

          , Object_PriceList.Id                               AS PriceListId         --����� ����
          , Object_PriceList.ValueData                        AS PriceListName       --����� ����
          , NULL::TDateTime                                   AS StartPromo          --���� ������ �����
          , NULL::TDateTime                                   AS EndPromo            --���� ��������� �����
          , NULL::TDateTime                                   AS OperDateStart       --���� ������ ����. ������ �� �����
          , NULL::TDateTime                                   AS OperDateEnd         --���� ��������� ����. ������ �� �����
          , NULL::TFloat                                      AS CostPromo           --��������� ������� � �����
          , NULL::TFloat                                      AS ChangePercent       --(-)% ������ (+)% ������� �� ��������
          , NULL::TVarChar                                    AS Comment             --����������
          , NULL::Integer                                     AS PersonalTradeId     --������������� ������������� ������������� ������
          , NULL::TVarChar                                    AS PersonalTradeName   --������������� ������������� ������������� ������

          , Object_SignInternal.Id                            AS SignInternalId
          , Object_SignInternal.ValueData                     AS SignInternalName
          , NULL::Integer                                     AS PromoTradeStateKindId   -- ��������� �����
          , NULL::TVarChar                                    AS PromoTradeStateKindName -- ��������� �����
          , NULL::TDateTime                                   AS CheckDate          -- ���� ������������
          , FALSE::Boolean                                    AS Checked            -- �����������

          , '' :: TVarChar AS strSign
          , '' :: TVarChar AS strSignNo

          , CURRENT_TIMESTAMP      ::TDateTime                AS InsertDate
          , Object_User.ValueData  ::TVarChar                 AS InsertName

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            LEFT OUTER JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
            LEFT JOIN Object AS Object_User ON Object_User.Id = vbUserId
            LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = vbSignInternalId
        ;
    ELSE
        RETURN QUERY

        WITH tmpSign AS (SELECT tmpSign.Id AS MovementId
                              , tmpSign.strSign
                              , tmpSign.strSignNo
                              , tmpSign.SignInternalId
                         FROM lpSelect_MI_Sign (inMovementId:= inMovementId ) AS tmpSign
                        )
    SELECT
        Movement_PromoTrade.Id                                                 --�������������
      , Movement_PromoTrade.InvNumber :: Integer         AS InvNumber          --����� ���������
      , ('� ' || Movement_PromoTrade.InvNumber || ' �� ' || zfConvert_DateToString (Movement_PromoTrade.OperDate)  ) :: TVarChar AS InvNumberFull
      , Movement_PromoTrade.OperDate                                           --���� ���������
      , Object_Status.ObjectCode                    AS StatusCode         --��� �������
      , Object_Status.ValueData                     AS StatusName         --������
      , MovementLinkObject_Contract.ObjectId        AS ContractId        --
      , Object_Contract.ValueData                   AS ContractName      --
      , Object_PaidKind.Id                          AS PaidKindId
      , Object_PaidKind.ValueData                   AS PaidKindName      
      , Object_ContractTag.Id                       AS ContractTagId
      , Object_ContractTag.ValueData                AS ContractTagName
      , Object_Juridical.Id                         AS JuridicalId
      , Object_Juridical.ValueData                  AS JuridicalName
      , Object_Retail.Id                            AS RetailId
      , Object_Retail.ValueData                     AS RetailNam�
      , MovementLinkObject_PromoKind.ObjectId       AS PromoKindId        --��� �����
      , Object_PromoKind.ValueData                  AS PromoKindName      --��� �����
      , Object_PromoItem.Id                         AS PromoItemId        --
      , Object_PromoItem.ValueData                  AS PromoItemName      --
      , MovementLinkObject_PriceList.ObjectId       AS PriceListId        --����� ����
      , Object_PriceList.ValueData                  AS PriceListName      --����� ����
      , MovementDate_StartPromo.ValueData           AS StartPromo         --���� ������ �����
      , MovementDate_EndPromo.ValueData             AS EndPromo           --���� ��������� �����
      , MovementDate_OperDateStart.ValueData        AS OperDateStart      --���� ������ ����. ������ �� �����
      , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --���� ��������� ����. ������ �� �����
      , MovementFloat_CostPromo.ValueData           AS CostPromo          --��������� ������� � �����
      , MovementFloat_ChangePercent.ValueData       AS ChangePercent      --(-)% ������ (+)% ������� �� ��������
      , MovementString_Comment.ValueData            AS Comment            --����������
      , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --������������� ������������� ������������� ������
      , Object_PersonalTrade.ValueData              AS PersonalTradeName  --������������� ������������� ������������� ������

      , Object_SignInternal.Id                                         AS SignInternalId
      , Object_SignInternal.ValueData                                  AS SignInternalName
      , Object_PromoTradeStateKind.Id                                  AS PromoTradeStateKindId   -- ��������� �����
      , Object_PromoTradeStateKind.ValueData                           AS PromoTradeStateKindName -- ��������� �����
      , MovementDate_CheckDate.ValueData                               AS CheckDate          -- ���� ������������
      , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked            -- �����������

      , tmpSign.strSign
      , tmpSign.strSignNo

      , MovementDate_Insert.ValueData               AS InsertDate
      , Object_Insert.ValueData                     AS InsertName

    FROM Movement AS Movement_PromoTrade
        LEFT JOIN tmpSign ON tmpSign.MovementId = Movement_PromoTrade.Id

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PromoTrade.StatusId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract
                         ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoKind
                                     ON MovementLinkObject_PromoKind.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_PromoKind.DescId = zc_MovementLinkObject_PromoKind()
        LEFT JOIN Object AS Object_PromoKind
                         ON Object_PromoKind.Id = MovementLinkObject_PromoKind.ObjectId


        LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                     ON MovementLinkObject_PriceList.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
        LEFT JOIN Object AS Object_PriceList
                         ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

        LEFT JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement_PromoTrade.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId =  Movement_PromoTrade.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                               ON MovementDate_OperDateStart.MovementId = Movement_PromoTrade.Id
                              AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                               ON MovementDate_OperDateEnd.MovementId = Movement_PromoTrade.Id
                              AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

        LEFT JOIN MovementFloat AS MovementFloat_CostPromo
                                ON MovementFloat_CostPromo.MovementId = Movement_PromoTrade.Id
                               AND MovementFloat_CostPromo.DescId = zc_MovementFloat_CostPromo()

        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId = Movement_PromoTrade.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_PromoTrade.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                     ON MovementLinkObject_PersonalTrade.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
        LEFT JOIN Object AS Object_PersonalTrade
                         ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoItem
                                     ON MovementLinkObject_PromoItem.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_PromoItem.DescId = zc_MovementLinkObject_PromoItem()
        LEFT JOIN Object AS Object_PromoItem ON Object_PromoItem.Id = MovementLinkObject_PromoItem.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                     ON MovementLinkObject_PaidKind.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_PromoTrade.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                     ON MovementLinkObject_Insert.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                             ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                            AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
        LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                             ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_SignInternal
                                     ON MovementLinkObject_SignInternal.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_SignInternal.DescId = zc_MovementLinkObject_SignInternal()
        LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = MovementLinkObject_SignInternal.ObjectId

        LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                  ON MovementBoolean_Checked.MovementId = Movement_PromoTrade.Id
                                 AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
        LEFT JOIN MovementDate AS MovementDate_CheckDate
                               ON MovementDate_CheckDate.MovementId = Movement_PromoTrade.Id
                              AND MovementDate_CheckDate.DescId = zc_MovementDate_Check()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoTradeStateKind
                                     ON MovementLinkObject_PromoTradeStateKind.MovementId = Movement_PromoTrade.Id
                                    AND MovementLinkObject_PromoTradeStateKind.DescId = zc_MovementLinkObject_PromoTradeStateKind()
        LEFT JOIN Object AS Object_PromoTradeStateKind ON Object_PromoTradeStateKind.Id = MovementLinkObject_PromoTradeStateKind.ObjectId

    WHERE Movement_PromoTrade.DescId = zc_Movement_PromoTrade()
      AND Movement_PromoTrade.Id =  inMovementId
    ;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.24         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_PromoTrade (inMovementId:= 1, inOperDate:= '30.11.2015', inMask:= False, inSession:= zfCalc_UserAdmin())
