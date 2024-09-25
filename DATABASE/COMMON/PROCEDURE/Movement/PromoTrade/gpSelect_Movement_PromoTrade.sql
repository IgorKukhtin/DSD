-- Function: gpSelect_Movement_PromoTrade()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoTrade (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoTrade(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- ������ ������������
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
             , PromoItemName    TVarChar    -- ������ ������
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
             , PromoTradeStateKindId   Integer   -- ��������� �����
             , PromoTradeStateKindName TVarChar  -- ��������� �����
             , CheckDate        TDateTime   -- ���� ������������
             , isPromoStateKind Boolean     -- ��������� ��� ���������

             , strSign        TVarChar -- ��� �������������. - ���� ��. �������
             , strSignNo      TVarChar -- ��� �������������. - ��������� ��. �������

             , InsertDate TDateTime
             , InsertName TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- ���������
    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
           , tmpMovement AS (SELECT Movement_PromoTrade.*
                             FROM Movement AS Movement_PromoTrade
                                  INNER JOIN tmpStatus ON Movement_PromoTrade.StatusId = tmpStatus.StatusId
                             WHERE Movement_PromoTrade.DescId = zc_Movement_PromoTrade()
                               AND Movement_PromoTrade.OperDate BETWEEN inStartDate AND inEndDate
                            )
           , tmpSign AS (SELECT tmpMovement.Id
                              , tmpSign.strSign
                              , tmpSign.strSignNo
                              , tmpSign.SignInternalId
                         FROM tmpMovement
                              LEFT JOIN lpSelect_MI_Sign (inMovementId:= tmpMovement.Id ) AS tmpSign ON tmpSign.Id = tmpMovement.Id
                        )
        -- ���������
        SELECT Movement_PromoTrade.Id                                                 --�������������
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
             , MovementDate_OperDateStart.ValueData        AS OperDateStart      --���� ������ ����. ������
             , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --���� ��������� ����. ������
             , MovementFloat_CostPromo.ValueData           AS CostPromo          --��������� ������� � �����
             , MovementFloat_ChangePercent.ValueData       AS ChangePercent      --(-)% ������ (+)% ������� �� ��������
             , MovementString_Comment.ValueData            AS Comment            --����������
             , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --������������� ������������� ������������� ������
             , Object_PersonalTrade.ValueData              AS PersonalTradeName  --������������� ������������� ������������� ������

             , Object_SignInternal.Id                                         AS SignInternalId
             , Object_SignInternal.ValueData                                  AS SignInternalName
             , Object_PromoTradeStateKind.Id                                  AS PromoStateKindId   -- ��������� �����
             , Object_PromoTradeStateKind.ValueData                           AS PromoStateKindName -- ��������� �����
             , MovementDate_CheckDate.ValueData                               AS CheckDate          -- ���� ������������
             , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked            -- �����������

             , tmpSign.strSign
             , tmpSign.strSignNo

             , MovementDate_Insert.ValueData               AS InsertDate
             , Object_Insert.ValueData                     AS InsertName

        FROM tmpMovement AS Movement_PromoTrade
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

             -- ��.�������
             LEFT JOIN tmpSign ON tmpSign.Id = Movement_PromoTrade.Id
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.24         *
*/

-- SELECT * FROM gpSelect_Movement_PromoTrade (inStartDate:= '01.08.2024', inEndDate:= '15.08.2024', inIsErased:= true, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
