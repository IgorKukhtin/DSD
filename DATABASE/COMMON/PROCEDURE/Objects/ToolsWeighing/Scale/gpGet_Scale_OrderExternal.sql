-- Function: gpGet_Scale_OrderExternal()

DROP FUNCTION IF EXISTS gpGet_Scale_OrderExternal (TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_OrderExternal(
    IN inOperDate       TDateTime   ,
    IN inBranchCode     Integer   , --
    IN inBarCode        TVarChar    ,
    IN inSession        TVarChar      -- ������ ������������
)
RETURNS TABLE (MovementId            Integer
             , MovementDescId_order  Integer
             , MovementId_get        Integer -- �������� ����������� !!!������ ��� ������!!!, ����� ����������� � MovementId
             , BarCode               TVarChar
             , InvNumber             TVarChar
             , InvNumberPartner      TVarChar

             , MovementDescNumber Integer -- !!!������ ��� zc_Movement_SendOnPrice!!!
             , MovementDescId     Integer -- !!!������ ��� �������� ���������!!!
             , FromId         Integer, FromCode         Integer, FromName       TVarChar
             , ToId           Integer, ToCode           Integer, ToName         TVarChar
             , PaidKindId     Integer, PaidKindName   TVarChar

             , PriceListId     Integer, PriceListCode     Integer, PriceListName     TVarChar
             , ContractId      Integer, ContractCode      Integer, ContractNumber    TVarChar, ContractTagName TVarChar
             , GoodsPropertyId Integer, GoodsPropertyCode Integer, GoodsPropertyName TVarChar

             , PartnerId_calc   Integer
             , PartnerCode_calc Integer
             , PartnerName_calc TVarChar
             , ChangePercent    TFloat
             , ChangePercentAmount TFloat

             , isEdiOrdspr      Boolean
             , isEdiInvoice     Boolean
             , isEdiDesadv      Boolean

             , isMovement    Boolean, CountMovement   TFloat   -- ���������
             , isAccount     Boolean, CountAccount    TFloat   -- ����
             , isTransport   Boolean, CountTransport  TFloat   -- ���
             , isQuality     Boolean, CountQuality    TFloat   -- ������������
             , isPack        Boolean, CountPack       TFloat   -- �����������
             , isSpec        Boolean, CountSpec       TFloat   -- ������������
             , isTax         Boolean, CountTax        TFloat   -- ���������

             , OrderExternalName_master TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbBranchId   Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
   -- ����� ��������� ����� ������ ���������� ����.
   vbOperDate_Begin1:= CLOCK_TIMESTAMP();

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);


    -- ��������
    IF (vbBranchId :: Integer) > 1000
    THEN
        RAISE EXCEPTION '������.��� ������ �������� ����������� ������.';
    END IF;

    -- ������������
    vbBranchId:= CASE WHEN inBranchCode > 100 THEN zc_Branch_Basis()
                      ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch())
                 END;

    -- ������
    CREATE TEMP TABLE _tmpMovement_find_all ON COMMIT DROP
                              AS (WITH tmpBarCode   AS (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId WHERE CHAR_LENGTH (inBarCode) >= 13)
                                     , tmpInvNumber AS (SELECT inBarCode AS BarCode WHERE CHAR_LENGTH (inBarCode) > 0 AND CHAR_LENGTH (inBarCode) < 13)
                                  -- �� �/�
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                  FROM Movement
                                  WHERE Movement.Id IN (SELECT DISTINCT tmpBarCode.MovementId FROM tmpBarCode)
                                   AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderInternal(), zc_Movement_SendOnPrice())
                                   AND Movement.OperDate BETWEEN inOperDate - INTERVAL '18 DAY' AND inOperDate + INTERVAL '8 DAY'
                                   AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 UNION
                                  -- �� �/� - ������, �.�. ������ 80 ����
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                  FROM Movement
                                  WHERE Movement.Id IN (SELECT DISTINCT tmpBarCode.MovementId FROM tmpBarCode)
                                    AND Movement.DescId = zc_Movement_OrderIncome()
                                    AND Movement.OperDate BETWEEN inOperDate - INTERVAL '80 DAY' AND inOperDate + INTERVAL '80 DAY'
                                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    AND inBranchCode BETWEEN 301 AND 310
                                 UNION
                                  -- �� � ���������
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                  FROM tmpInvNumber AS tmp
                                       INNER JOIN Movement ON Movement.InvNumber = tmp.BarCode
                                                          AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderInternal(), zc_Movement_SendOnPrice())
                                                          AND Movement.OperDate BETWEEN inOperDate - INTERVAL '18 DAY' AND inOperDate + INTERVAL '8 DAY'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 UNION
                                  -- �� � ��������� - ������, �.�. ������ 80 ����
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                  FROM tmpInvNumber AS tmp
                                       INNER JOIN Movement ON Movement.InvNumber = tmp.BarCode
                                                          AND Movement.DescId = zc_Movement_OrderIncome()
                                                          AND Movement.OperDate BETWEEN inOperDate - INTERVAL '80 DAY' AND inOperDate + INTERVAL '80 DAY'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                  WHERE inBranchCode BETWEEN 301 AND 310
                                 );

    -- ANALYZE
    ANALYZE _tmpMovement_find_all;

    -- ���������
    RETURN QUERY
       WITH tmpUnit_Branch AS (SELECT OL.ObjectId AS UnitId
                               FROM ObjectLink AS OL
                               WHERE OL.ChildObjectId = vbBranchId
                                 AND OL.DescId        = zc_ObjectLink_Unit_Branch()
                              UNION
                               -- ������
                               SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8453) AS lfSelect
                               WHERE vbBranchId = zc_Branch_Basis()
                              )
          , tmpMovement AS (SELECT tmpMovement.Id
                                 , tmpMovement.InvNumber
                                 , tmpMovement.DescId
                                 , tmpMovement.OperDate

                                 , Object_From.DescId     AS DescId_From
                                 , Object_From.ObjectCode AS FromCode
                                 , Object_From.ValueData  AS FromName

                                 , Object_To.DescId       AS DescId_To
                                 , Object_To.ObjectCode   AS ToCode
                                 , Object_To.ValueData    AS ToName

                                   -- ContractId
                                 , MovementLinkObject_Contract.ObjectId AS ContractId
 
                                   -- �� ����
                                 , CASE -- ��� ������ ����������
                                        WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                                        
                                             THEN MovementLinkObject_Unit.ObjectId

                                        -- ��� ��������� - ������ ���������� ��� SendOnPrice
                                        ELSE MovementLinkObject_From.ObjectId

                                   END AS FromId

                                   -- ����
                                 , CASE -- ��� ������ ����������
                                        WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                                             THEN (SELECT OL.ObjectId
                                                   FROM MovementLinkObject AS MLO
                                                        INNER JOIN ObjectLink AS OL ON OL.ChildObjectId = MLO.ObjectId AND OL.DescId = zc_ObjectLink_Partner_Juridical()
                                                        INNER JOIN Object ON Object.Id = OL.ObjectId AND Object.isErased = FALSE
                                                   WHERE MLO.MovementId = tmpMovement.Id
                                                     AND MLO.DescId     = zc_MovementLinkObject_Juridical()
                                                   LIMIT 1)
                                        -- ��� ����� ������ + ����� ���������
                                        WHEN MovementLinkObject_From.ObjectId = MovementLinkObject_To.ObjectId
                                         AND inBranchCode BETWEEN 301 AND 310
                                         AND tmpMovement.DescId = zc_Movement_OrderInternal()
                                             THEN 8455 -- ����� ������

                                        -- ��� ��������� - ������ ���������� ��� SendOnPrice
                                        ELSE MovementLinkObject_To.ObjectId

                                   END AS ToId

                                   -- JuridicalId
                                 , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                   -- GoodsPropertyId
                                 , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, ObjectLink_Partner_Juridical.ChildObjectId, ObjectLink_Partner_Juridical.ObjectId) AS GoodsPropertyId

                                   -- ��� ����� ������� CASE ������������ ������ ��� ������
                                 , CASE -- ��� ���� - ������ � ���� !!!�����������!!!
                                        WHEN tmpUnit_Branch_From.UnitId > 0
                                         AND tmpMovement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_SendOnPrice())
                                             THEN NULL

                                        -- ��� ���� - ������ �� ����
                                        WHEN tmpUnit_Branch_To.UnitId > 0
                                         AND tmpMovement.DescId = zc_Movement_OrderExternal()
                                             THEN FALSE -- ����� ������ � ����

                                        -- ��� ���� - SendOnPrice �� ����
                                        WHEN tmpUnit_Branch_To.UnitId > 0
                                         AND tmpMovement.DescId = zc_Movement_SendOnPrice()
                                             THEN TRUE -- ����� ������ �� ����

                                        /*WHEN MovementLinkObject_From.ObjectId = 3080691 -- ����� �� �.�����
                                         AND MovementLinkObject_To.ObjectId   = 8411    -- ����� �� �.����
                                         AND tmpMovement.DescId = zc_Movement_OrderInternal()
                                             THEN FALSE -- ��� ���� - ������ � ����
                                        */

                                        /*WHEN ObjectLink_UnitFrom_Branch.ChildObjectId = vbBranchId
                                             THEN NULL -- FALSE -- ��� ������� - ������ � ���� !!!�����������!!!
                                        WHEN ObjectLink_UnitTo_Branch.ChildObjectId = vbBranchId
                                             THEN TRUE -- ��� ������� - ������ �� ����
                                        WHEN ObjectLink_UnitTo_Branch.ChildObjectId > 0
                                             THEN NULL -- FALSE -- ��� �������� - ������ � ���� !!!�����������!!!
                                        WHEN ObjectLink_UnitFrom_Branch.ChildObjectId > 0
                                             THEN TRUE -- ��� �������� - ������ �� ����
                                        */

                                   END AS isSendOnPriceIn

                            FROM _tmpMovement_find_all AS tmpMovement

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                              ON MovementLinkObject_Contract.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                              ON MovementLinkObject_Partner.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                             
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                      ON ObjectLink_Partner_Juridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                 LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                                      ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                                     AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                 LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                                      ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                                                     AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()

                                 LEFT JOIN tmpUnit_Branch AS tmpUnit_Branch_From ON tmpUnit_Branch_From.UnitId = MovementLinkObject_From.ObjectId
                                 LEFT JOIN tmpUnit_Branch AS tmpUnit_Branch_To   ON tmpUnit_Branch_To.UnitId   = MovementLinkObject_To.ObjectId

                                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                 LEFT JOIN Object AS Object_To   ON Object_To.Id   = MovementLinkObject_To.ObjectId
                           )
           , tmpMovement_find AS (SELECT tmpMovement.Id
                                       , MovementLinkMovement_Order.MovementId AS MovementId_get
                                  FROM tmpMovement
                                       INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                       ON MovementLinkMovement_Order.MovementChildId = tmpMovement.Id
                                                                      AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                       INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                          AND Movement.DescId = zc_Movement_WeighingPartner()
                                                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                       INNER JOIN MovementLinkObject
                                               AS MovementLinkObject_User
                                               ON MovementLinkObject_User.MovementId = Movement.Id
                                              AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                              AND MovementLinkObject_User.ObjectId = vbUserId
                                              -- AND vbUserId <> 5
                                 )
           , tmpJuridicalPrint AS (SELECT tmpGet.Id AS JuridicalId
                                        , tmpGet.isMovement, tmpGet.CountMovement
                                        , tmpGet.isAccount, tmpGet.CountAccount
                                        , tmpGet.isTransport, tmpGet.CountTransport
                                        , tmpGet.isQuality, tmpGet.CountQuality
                                        , tmpGet.isPack, tmpGet.CountPack
                                        , tmpGet.isSpec, tmpGet.CountSpec
                                        , tmpGet.isTax, tmpGet.CountTax
                                   FROM (SELECT tmpMovement.JuridicalId FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_OrderExternal() LIMIT 1) AS tmp
                                        INNER JOIN lpGet_Object_Juridical_PrintKindItem ((SELECT tmpMovement.JuridicalId FROM tmpMovement LIMIT 1)) AS tmpGet ON tmpGet.Id = tmp.JuridicalId
                                  )
      , tmpMovementDescNumber AS (SELECT tmpSelect.Number AS MovementDescNumber
                                       , tmp.MovementId
                                  FROM (SELECT -- !!!������!!!
                                               CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                                                         THEN zc_Movement_Income()
                                                    WHEN tmpMovement.DescId = zc_Movement_OrderInternal()
                                                         THEN zc_Movement_Send()
                                                    WHEN tmpMovement.DescId_From = zc_Object_ArticleLoss()
                                                         THEN zc_Movement_Loss()
                                                    /*WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                                                     AND tmpMovement.FromId = 3080691 -- ����� �� �.�����
                                                     AND tmpMovement.ToId   = 8411    -- ����� �� �.����
                                                         THEN zc_Movement_Send()*/
                                                    WHEN tmpMovement.DescId_From = zc_Object_Unit()
                                                         THEN zc_Movement_SendOnPrice()

                                                    ELSE tmpMovement.DescId

                                               END AS MovementDescId

                                             , tmpMovement.DescId AS MovementDescId_original
                                             , tmpMovement.FromId
                                             , tmpMovement.ToId
                                             , tmpMovement.isSendOnPriceIn
                                             , tmpMovement.Id AS MovementId
                                        FROM tmpMovement
                                             -- LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
                                        WHERE tmpMovement.DescId = zc_Movement_OrderIncome()
                                           OR tmpMovement.DescId = zc_Movement_SendOnPrice()
                                        -- OR Object_From.DescId = zc_Object_ArticleLoss()
                                        -- OR Object_From.DescId = zc_Object_Unit()
                                           OR tmpMovement.DescId_From = zc_Object_ArticleLoss()
                                           OR tmpMovement.DescId_From = zc_Object_Unit()
                                       ) AS tmp
                                       INNER JOIN gpSelect_Object_ToolsWeighing_MovementDesc (inBranchCode:= inBranchCode
                                                                                            , inSession   := inSession
                                                                                             )
                                                   AS tmpSelect ON tmpSelect.MovementDescId = tmp.MovementDescId
                                                               AND tmpSelect.FromId = CASE -- ��� ������� �� ����������
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Income()
                                                                                                THEN 0
                                                                                           -- ��� �����������
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Send()
                                                                                                THEN tmp.ToId
                                                                                           -- ��� ��������
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Loss()
                                                                                                THEN tmp.ToId
--    WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
--     AND tmp.FromId = 3080691 -- ����� �� �.�����
--     AND tmp.ToId   = 8411    -- ����� �� �.����
--         THEN tmp.ToId
                                                                                           -- ��� ������ SendOnPrice �� ������
                                                                                           WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() AND tmp.MovementDescId_original = zc_Movement_OrderExternal()
                                                                                                THEN tmp.ToId
                                                                                           -- ��� �������� - ������ � ����
                                                                                           WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = FALSE
                                                                                                THEN tmp.FromId
                                                                                           -- ��� �������� - ������ �� ����, � ����� 0 �.�. �� ���������� �� �����������
                                                                                           WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = TRUE
                                                                                                THEN 0
                                                                                           -- ��� ������� - ������ �� ����, � ����� FromId �.�. �� ����������
                                                                                           WHEN tmp.isSendOnPriceIn = TRUE
                                                                                                THEN tmp.FromId
                                                                                           -- ��� ��� ������� - ������ � ����
                                                                                           WHEN tmp.isSendOnPriceIn = FALSE
                                                                                                THEN tmp.FromId
                                                                                      END
                                                               AND tmpSelect.ToId   = CASE -- ��� ������� �� ����������
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Income()
                                                                                                THEN tmp.FromId
                                                                                           -- ��� �����������
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Send()
                                                                                                THEN tmp.FromId
                                                                                           -- ��� �������� ����� 0 �.�. �� ���������� �� �����������
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Loss()
                                                                                                THEN 0
--    WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
--     AND tmp.FromId = 3080691 -- ����� �� �.�����
--     AND tmp.ToId   = 8411    -- ����� �� �.����
--         THEN tmp.FromId
                                                                                           -- ��� �������� SendOnPrice �� ������
                                                                                           WHEN vbBranchId = zc_Branch_Basis() AND tmp.MovementDescId = zc_Movement_SendOnPrice() AND tmp.MovementDescId_original = zc_Movement_OrderExternal()
                                                                                                THEN 0
                                                                                           -- ��� ������� SendOnPrice �� ������
                                                                                           WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() AND tmp.MovementDescId_original = zc_Movement_OrderExternal()
                                                                                                THEN tmp.FromId
                                                                                           -- ��� �������� - ������ � ����, � ����� 0 �.�. �� ���������� �� �����������
                                                                                           WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = FALSE
                                                                                                THEN 0
                                                                                           -- ��� �������� - ������ �� ����
                                                                                           WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = TRUE
                                                                                                THEN tmp.ToId
                                                                                           -- ��� ������� - ������ �� ����
                                                                                           WHEN tmp.isSendOnPriceIn = TRUE
                                                                                                THEN tmp.ToId
                                                                                           -- ��� ��� ������� - ������ � ����, � ����� ToId �.�. �� ����������
                                                                                           WHEN tmp.isSendOnPriceIn = FALSE
                                                                                                THEN tmp.ToId
                                                                                      END
                                                               AND COALESCE (tmpSelect.PaidKindId, 0) = CASE WHEN tmp.MovementDescId = zc_Movement_Income()
                                                                                                                  THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = tmp.MovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind())
                                                                                                             ELSE COALESCE (tmpSelect.PaidKindId, 0)
                                                                                                        END
                                 )
           , tmpMLO_PriceList AS (SELECT * FROM MovementLinkObject AS MLO_PriceList
                                  WHERE MLO_PriceList.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                                    AND MLO_PriceList.DescId     = zc_MovementLinkObject_PriceList()
                                 )
       -- ���������
       SELECT tmpMovement.Id                                 AS MovementId
            , tmpMovement.DescId                             AS MovementDescId_order
            , tmpMovement_find.MovementId_get                AS MovementId_get
            , inBarCode                                      AS BarCode
            , tmpMovement.InvNumber                          AS InvNumber
            , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner

            , tmpMovementDescNumber.MovementDescNumber       AS MovementDescNumber -- !!!������ ��� zc_Movement_SendOnPrice!!!
            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN zc_Movement_Income()
                   WHEN tmpMovement.DescId = zc_Movement_OrderInternal()
                        THEN zc_Movement_Send()
                   WHEN tmpMovement.DescId_From = zc_Object_ArticleLoss()
                        THEN zc_Movement_Loss()

                   /*WHEN (tmpMovement.DescId = zc_Movement_OrderExternal()
                    AND tmpMovement.FromId = 3080691 -- ����� �� �.�����
                    AND tmpMovement.ToId   = 8411    -- ����� �� �.����
                    ) -- or inSession = '5'
                        THEN zc_Movement_Send()*/

                   WHEN tmpMovement.DescId_From = zc_Object_Unit()
                        THEN zc_Movement_SendOnPrice()

                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN zc_Movement_Sale()

                   ELSE tmpMovement.DescId

              END AS MovementDescId
            , tmpMovement.FromId                             AS FromId
            , tmpMovement.FromCode                           AS FromCode
            , tmpMovement.FromName                           AS FromName
            , tmpMovement.ToId                               AS ToId
            , tmpMovement.ToCode                             AS ToCode
            , tmpMovement.ToName                             AS ToName
            , Object_PaidKind.Id                             AS PaidKindId
            , Object_PaidKind.ValueData                      AS PaidKindName

            , Object_PriceList.Id                            AS PriceListId
            , Object_PriceList.ObjectCode                    AS PriceListCode
            , Object_PriceList.ValueData                     AS PriceListName
            , View_Contract_InvNumber.ContractId             AS ContractId
            , View_Contract_InvNumber.ContractCode           AS ContractCode
            , View_Contract_InvNumber.InvNumber              AS ContractNumber
            , View_Contract_InvNumber.ContractTagName        AS ContractTagName

            , Object_GoodsProperty.Id                        AS GoodsPropertyId
            , Object_GoodsProperty.ObjectCode                AS GoodsPropertyCode
            , Object_GoodsProperty.ValueData                 AS GoodsPropertyName

            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN tmpMovement.ToId
                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN tmpMovement.FromId
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = TRUE
                        THEN tmpMovement.FromId
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = FALSE
                        THEN tmpMovement.ToId
              END :: Integer AS PartnerId_calc
            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN tmpMovement.ToCode
                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN tmpMovement.FromCode
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = TRUE
                        THEN tmpMovement.FromCode
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = FALSE
                        THEN tmpMovement.ToCode
              END :: Integer AS PartnerCode_calc
            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN tmpMovement.ToName
                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN tmpMovement.FromName
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = TRUE
                        THEN tmpMovement.FromName
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = FALSE
                        THEN tmpMovement.ToName
              END :: TVarChar AS PartnerName_calc

            , MovementFloat_ChangePercent.ValueData AS ChangePercent
            , (SELECT tmp.ChangePercentAmount FROM gpGet_Scale_Partner (inOperDate       := inOperDate
                                                                      , inMovementDescId := CASE WHEN tmpMovement.DescId_From = zc_Object_ArticleLoss()
                                                                                                      THEN zc_Movement_Loss()
                                                                                                 WHEN tmpMovement.DescId_From = zc_Object_Unit() AND tmpMovement.DescId = zc_Movement_OrderExternal()
                                                                                                      THEN zc_Movement_SendOnPrice()
                                                                                                 WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                                                                                                      THEN zc_Movement_Sale()
                                                                                                 ELSE tmpMovement.DescId
                                                                                            END
                                                                      , inPartnerCode    := -1 * tmpMovement.FromId
                                                                      , inInfoMoneyId    := COALESCE (View_Contract_InvNumber.InfoMoneyId, zc_Enum_InfoMoney_30101())
                                                                      , inPaidKindId     := Object_PaidKind.Id
                                                                      , inSession        := inSession
                                                                       ) AS tmp
               WHERE COALESCE (tmp.ContractId, 0) = COALESCE (View_Contract_InvNumber.ContractId, 0)
                  OR tmpMovement.DescId_From = zc_Object_Unit()
              ) AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

            , CASE WHEN tmpJuridicalPrint.isPack = TRUE OR tmpJuridicalPrint.isSpec = TRUE THEN COALESCE (tmpJuridicalPrint.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , CASE WHEN tmpJuridicalPrint.CountMovement > 0 THEN tmpJuridicalPrint.CountMovement ELSE 2 END :: TFloat AS CountMovement
            , COALESCE (tmpJuridicalPrint.isAccount,   FALSE) :: Boolean AS isAccount,   COALESCE (tmpJuridicalPrint.CountAccount, 0)   :: TFloat AS CountAccount
            , COALESCE (tmpJuridicalPrint.isTransport, FALSE) :: Boolean AS isTransport, COALESCE (tmpJuridicalPrint.CountTransport, 0) :: TFloat AS CountTransport
            , COALESCE (tmpJuridicalPrint.isQuality,   FALSE) :: Boolean AS isQuality  , COALESCE (tmpJuridicalPrint.CountQuality, 0)   :: TFloat AS CountQuality
            , COALESCE (tmpJuridicalPrint.isPack,      FALSE) :: Boolean AS isPack     , COALESCE (tmpJuridicalPrint.CountPack, 0)      :: TFloat AS CountPack
            , COALESCE (tmpJuridicalPrint.isSpec,      FALSE) :: Boolean AS isSpec     , COALESCE (tmpJuridicalPrint.CountSpec, 0)      :: TFloat AS CountSpec
            , COALESCE (tmpJuridicalPrint.isTax,       FALSE) :: Boolean AS isTax      , COALESCE (tmpJuridicalPrint.CountTax, 0)       :: TFloat AS CountTax

            , ('� <' || tmpMovement.InvNumber || '>' || ' �� <' || DATE (tmpMovement.OperDate) :: TVarChar || '>' || ' '|| COALESCE (Object_Personal.ValueData, '')) :: TVarChar AS OrderExternalName_master

       FROM tmpMovement
            LEFT JOIN tmpMovement_find ON tmpMovement_find.Id = tmpMovement.Id
            LEFT JOIN tmpMovementDescNumber ON tmpMovementDescNumber.MovementDescNumber > 0
            LEFT JOIN tmpJuridicalPrint ON tmpJuridicalPrint.JuridicalId = tmpMovement.JuridicalId

            -- LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
            -- LEFT JOIN Object AS Object_To   ON Object_To.Id   = tmpMovement.ToId

            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpMovement.ContractId
            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = tmpMovement.GoodsPropertyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                        AND tmpMovement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderIncome())
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                        AND tmpMovement.DescId = zc_Movement_OrderIncome()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                 ON ObjectLink_Juridical_PriceList.ObjectId = MovementLinkObject_Juridical.ObjectId 
                                AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()

            -- LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
            LEFT JOIN tmpMLO_PriceList AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_PriceList.DescId     = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (ObjectLink_Juridical_PriceList.ChildObjectId, CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome() THEN zc_PriceList_Basis() ELSE MovementLinkObject_PriceList.ObjectId END)

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  tmpMovement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  tmpMovement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = tmpMovement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiOrdspr
                                    ON ObjectBoolean_Partner_EdiOrdspr.ObjectId =  tmpMovement.FromId
                                   AND ObjectBoolean_Partner_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- �������� �� ����� ������ � EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiInvoice
                                    ON ObjectBoolean_Partner_EdiInvoice.ObjectId =  tmpMovement.FromId
                                   AND ObjectBoolean_Partner_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- �������� �� ����� ������ � EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiDesadv
                                    ON ObjectBoolean_Partner_EdiDesadv.ObjectId =  tmpMovement.FromId
                                   AND ObjectBoolean_Partner_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- �������� �� ����� ������ � EDI

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId
      ;

     -- !!!�������� - �������� - �����������!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- �� ������� ��������
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- ������� ����� ����������� ����
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- ������� ����� ����������� ���� �� lpSelectMinPrice_List
             , NULL AS Time2
               -- ������� ����� ����������� ���� lpSelectMinPrice_List
             , NULL AS Time3
               -- ������� ����� ����������� ���� ����� lpSelectMinPrice_List
             , NULL AS Time4
               -- �� ������� �����������
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpGet_Scale_OrderExternal'
               -- ProtocolData
             , zfConvert_DateToString (inOperDate)
    || ', ' || inBranchCode :: TVarChar
    || ', ' || inBarCode
    || ', ' || inSession
              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.01.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_Scale_OrderExternal (inOperDate := ('01.07.2015')::TDateTime , inBranchCode := 1 , inBarCode := '2020018777013' ,  inSession := '5');
-- SELECT * FROM gpGet_Scale_OrderExternal(inOperDate := CURRENT_DATE , inBranchCode := 301 , inBarCode := '135', inSession := '5');
