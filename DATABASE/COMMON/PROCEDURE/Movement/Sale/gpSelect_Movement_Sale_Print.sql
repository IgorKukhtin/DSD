-- Function: gpSelect_Movement_Sale_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbOperDate TdateTime;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbIsChangePrice Boolean;
    DECLARE vbIsDiscountPrice Boolean;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
    DECLARE vbTotalCountKg  TFloat;
    DECLARE vbTotalCountSh  TFloat;

    DECLARE vbIsProcess_BranchIn Boolean;

    DECLARE vbWeighingCount   Integer;
    DECLARE vbStoreKeeperName TVarChar;

    DECLARE vbIsInfoMoney_30201 Boolean;
    DECLARE vbIsInfoMoney_30200 Boolean;

    DECLARE vbKiev Integer;

    DECLARE vbIsLongUKTZED Boolean;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!! ��� �����
     vbKiev := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.Id = 8411 );


     -- ���-�� �����������
     vbWeighingCount:= (SELECT COUNT(*)
                        FROM Movement
                        WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       );

     -- ��������� �� �����������
     vbStoreKeeperName:= (SELECT Object_User.ValueData
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                            ON MovementLinkObject_User.MovementId = Movement.Id
                                                           AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
                          WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          LIMIT 1
                         );


     -- ��������
     IF EXISTS (SELECT 1
                FROM Movement
                     LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                            ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                           AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Sale()
                  AND COALESCE (MovementDate_OperDatePartner.ValueData, zc_DateStart()) < (Movement.OperDate - INTERVAL '5 DAY')
                  AND (EXTRACT (MONTH FROM Movement.OperDate) = EXTRACT (MONTH FROM CURRENT_DATE)
                    OR EXTRACT (MONTH FROM Movement.OperDate) = EXTRACT (MONTH FROM CURRENT_DATE - INTERVAL '7 DAY')
                      )
               )
     THEN
         RAISE EXCEPTION '������.� ��������� �� <%> �������� �������� ���� � ���������� <%>.', zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                                                                                             , zfConvert_DateToString ((SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner()));
     END IF;



     -- ��������� �� ���������
     SELECT Movement.OperDate
          , Movement.DescId
          , Movement.StatusId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN      MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)       AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)        AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)        AS ContractId
          , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE) AS isDiscountPrice_juridical
          , CASE WHEN COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) = zc_Enum_InfoMoney_30201() -- �������� ��� ������ �����
                     THEN TRUE
                 ELSE FALSE
            END AS isInfoMoney_30200
          , COALESCE (ObjectBoolean_isLongUKTZED.ValueData, TRUE)    AS isLongUKTZED

            INTO vbOperDate, vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbPaidKindId, vbContractId, vbIsDiscountPrice
               , vbIsInfoMoney_30200, vbIsLongUKTZED
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())

          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          -- LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
          --                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
          --                     AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                  ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isLongUKTZED
                                  ON ObjectBoolean_isLongUKTZED.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_isLongUKTZED.DescId = zc_ObjectBoolean_Juridical_isLongUKTZED()

          /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()*/
     WHERE Movement.Id = inMovementId AND Movement.DescId <> zc_Movement_SendOnPrice()
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;


     -- !!!���� ���������� - ���� �� ������ � ����!!!
     vbIsChangePrice:= vbIsDiscountPrice = TRUE                              -- � �� ���� ���� �����
                    OR vbPaidKindId = zc_Enum_PaidKind_FirstForm()           -- ��� ��
                    OR ((vbDiscountPercent > 0 OR vbExtraChargesPercent > 0) -- � ����� ���� ������, �� ���� ���� ���� ������� �� ������� = 0%
                        AND EXISTS (SELECT 1
                                    FROM MovementItem
                                         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                     ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId = zc_MI_Master()
                                      AND MovementItem.isErased = FALSE
                                      AND COALESCE (MIFloat_ChangePercent.ValueData, 0) = 0
                                   ));


     -- ������ �������� - ������ �� ������� ��� ������ � ������� (� ������ ����� �������� ������ "���� (������)")
     vbIsProcess_BranchIn:= EXISTS (SELECT Id FROM Object_Unit_View WHERE Id = (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To()) AND BranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId))
                           ;

    -- ����� ������ ��������
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- ��� ��� �������� ������
        RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;


    IF vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice()
    THEN
        -- ������ ����
        SELECT CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                         -- ���� ���� ��� ��� ��� %���=0
                         THEN OperSumm
                    WHEN vbPriceWithVAT AND 1=1
                         -- ���� ���� c ���
                         THEN CAST ( (OperSumm) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                    WHEN vbPriceWithVAT
                         -- ���� ���� c ��� (������� ����� ���� ���� �������� ������ ��� =1/6 )
                         THEN OperSumm - CAST ( (OperSumm) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
               END AS OperSumm_MVAT
               -- ����� � ���
             , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                         -- ���� ���� � ���
                         THEN (OperSumm)
                    WHEN vbVATPercent > 0
                         -- ���� ���� ��� ���
                         THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm) AS NUMERIC (16, 2))
               END AS OperSumm_PVAT
             , TotalCountKg
             , TotalCountSh

               INTO vbOperSumm_MVAT, vbOperSumm_PVAT
                  , vbTotalCountKg, vbTotalCountSh

        FROM
       (SELECT SUM (CASE WHEN tmpMI.CountForPrice <> 0
                              THEN CAST (tmpMI.Amount * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                         ELSE CAST (tmpMI.Amount * tmpMI.Price AS NUMERIC (16, 2))
                    END
                   ) AS OperSumm

                         -- ��
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.Amount
                              ELSE 0
                         END) AS TotalCountSh
                         -- ���
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.Amount * COALESCE (ObjectFloat_Weight.ValueData, 0)
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                   THEN tmpMI.Amount
                              ELSE 0
                         END) AS TotalCountKg

        FROM (SELECT MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                   , CASE WHEN MIFloat_ChangePercent.ValueData <> 0
                               THEN CAST ( (1 + MIFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          /*WHEN vbDiscountPercent <> 0
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))*/
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                   -- , SUM (MovementItem.Amount) AS Amount
                   , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                    THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                               WHEN Movement.DescId IN (zc_Movement_SendOnPrice()) AND vbIsProcess_BranchIn = TRUE
                                    THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                               ELSE MovementItem.Amount

                          END) AS Amount
              FROM MovementItem
                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                               ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               -- AND MIFloat_Price.ValueData <> 0
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.isErased = FALSE
              GROUP BY MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
                     , MIFloat_ChangePercent.ValueData
             ) AS tmpMI
                       LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                             ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
        ) AS tmpMI;
    END IF;


    -- �������� ��� ������ + ��������� + �������
    vbIsInfoMoney_30201:= EXISTS (SELECT 1
                                  FROM MovementItem
                                       INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                             ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                            AND ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30102()
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE);

     --
    OPEN Cursor1 FOR
--     WITH tmpObject_GoodsPropertyValue AS
       WITH tmpBankAccount AS (SELECT ObjectLink_BankAccountContract_BankAccount.ChildObjectId             AS BankAccountId
                                    , COALESCE (ObjectLink_BankAccountContract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId
                                    , COALESCE (ObjectLink_BankAccountContract_Unit.ChildObjectId, 0)      AS UnitId
                               FROM ObjectLink AS ObjectLink_BankAccountContract_BankAccount
                                    LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_InfoMoney
                                                         ON ObjectLink_BankAccountContract_InfoMoney.ObjectId = ObjectLink_BankAccountContract_BankAccount.ObjectId
                                                        AND ObjectLink_BankAccountContract_InfoMoney.DescId = zc_ObjectLink_BankAccountContract_InfoMoney()
                                    LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_Unit
                                                          ON ObjectLink_BankAccountContract_Unit.ObjectId = ObjectLink_BankAccountContract_InfoMoney.ObjectId
                                                         AND ObjectLink_BankAccountContract_Unit.DescId = zc_ObjectLink_BankAccountContract_Unit()
                               WHERE ObjectLink_BankAccountContract_BankAccount.DescId = zc_ObjectLink_BankAccountContract_BankAccount()
                                 AND ObjectLink_BankAccountContract_BankAccount.ChildObjectId IS NOT NULL
                              )
       SELECT
             Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
--         , Movement.InvNumber                         AS InvNumber
           , CASE WHEN Movement.DescId = zc_Movement_Sale()
                       THEN Movement.InvNumber
                  WHEN Movement.DescId = zc_Movement_TransferDebtOut() AND MovementString_InvNumberPartner.ValueData <> ''
                       THEN COALESCE (MovementString_InvNumberPartner.ValueData, Movement.InvNumber)
                  WHEN Movement.DescId = zc_Movement_TransferDebtOut() AND MovementString_InvNumberPartner.ValueData = ''
                       THEN Movement.InvNumber
                  ELSE Movement.InvNumber
             END AS InvNumber

           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner

           , CASE WHEN MovementString_InvNumberPartner_order.ValueData <> ''
                       THEN CASE WHEN zfConvert_StringToNumber (MovementString_InvNumberPartner_order.ValueData) <> 0
                                      THEN zfConvert_StringToNumber (MovementString_InvNumberPartner_order.ValueData) :: TVarChar
                                 ELSE MovementString_InvNumberPartner_order.ValueData
                            END
                  WHEN MovementString_InvNumberOrder.ValueData <> ''
                       THEN MovementString_InvNumberOrder.ValueData
                  ELSE COALESCE (Movement_order.InvNumber, '')
             END AS InvNumberOrder

           , EXTRACT (DAY FROM Movement.OperDate) :: Integer AS OperDate_day
           , COALESCE (EXTRACT (DAY FROM MovementDate_OperDatePartner.ValueData), 0) :: Integer AS OperDatePartner_day

           , Movement.OperDate                          AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData, CASE WHEN Movement.DescId <> zc_Movement_Sale() THEN Movement.OperDate END) :: TDateTime AS OperDatePartner
           , MovementDate_Payment.ValueData             AS PaymentDate
           , CASE WHEN MovementDate_Payment.ValueData IS NOT NULL THEN TRUE ELSE FALSE END :: Boolean AS isPaymentDate
           , COALESCE (Movement_order.OperDate, Movement.OperDate) :: TDateTime AS OperDateOrder
           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent
           , vbExtraChargesPercent - vbDiscountPercent  AS ChangePercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , FLOOR (MovementFloat_TotalCount.ValueData) AS TotalCount_floor
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbTotalCountKg ELSE MovementFloat_TotalCountKg.ValueData END AS TotalCountKg
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbTotalCountSh ELSE MovementFloat_TotalCountSh.ValueData END AS TotalCountSh
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_MVAT ELSE MovementFloat_TotalSummMVAT.ValueData END AS TotalSummMVAT
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_PVAT ELSE MovementFloat_TotalSummPVAT.ValueData END AS TotalSummPVAT
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_PVAT - vbOperSumm_MVAT ELSE MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData END AS SummVAT
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_PVAT ELSE MovementFloat_TotalSumm.ValueData END AS TotalSumm
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_PVAT ELSE MovementFloat_TotalSumm.ValueData *(1 - (vbVATPercent / (vbVATPercent + 100))) END TotalSummMVAT_Info
           , Object_From.ValueData             		AS FromName
           , CASE WHEN Object_From.Id = vbKiev THEN TRUE ELSE FALSE END AS isPrintPageBarCode
           , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName
           , Object_PaidKind.ValueData         		AS PaidKindName
           , View_Contract.InvNumber        		AS ContractName
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind
           , COALESCE (ObjectString_PartnerCode.ValueData, '') :: TVarChar AS PartnerCode

           , Object_RouteSorting.ValueData 	        AS RouteSortingName

           , /*CASE WHEN View_Contract.InfoMoneyId = zc_Enum_InfoMoney_30101() AND Object_From.Id = 8459
                   AND OH_JuridicalDetails_To.OKPO NOT IN ('32516492', '39135315', '39622918')
                       THEN '������� �.�.'
                  ELSE ''
             END*/
             CASE WHEN COALESCE (Object_PersonalStore_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_PersonalStore_View.PersonalName, 2, FALSE) ELSE vbStoreKeeperName END  AS StoreKeeper -- ���������
           , '' :: TVarChar                             AS Through     -- ����� ����
           , CASE WHEN OH_JuridicalDetails_To.OKPO IN ('32516492', '39135315', '39622918') THEN '�. ���, ��� �������, 18/22' ELSE '' END :: TVarChar  AS UnitAddress -- ������ ���������

           , CASE -- !!!����������� �������� ��� ���������!!!
                  WHEN MovementLinkObject_From.ObjectId IN (301309) -- ����� �� �.���������
                   AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                       THEN FALSE
                  WHEN ObjectLink_Contract_JuridicalDocument.ChildObjectId > 0
                   AND Movement.AccessKeyId <> zc_Enum_Process_AccessKey_DocumentKiev()
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isJuridicalDocument
           , CASE WHEN COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) = zc_Branch_Basis()
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isBranchBasis

           , ObjectString_Partner_ShortName.ValueData   AS ShortNamePartner_To
           , ObjectString_ToAddress.ValueData           AS PartnerAddress_To

           , (CASE WHEN ObjectString_PostalCode.ValueData  <> '' THEN ObjectString_PostalCode.ValueData || ' '      ELSE '' END
           || CASE WHEN View_Partner_Address.RegionName    <> '' THEN View_Partner_Address.RegionName   || ' ���., ' ELSE '' END
           || CASE WHEN View_Partner_Address.ProvinceName  <> '' THEN View_Partner_Address.ProvinceName || ' �-�, '  ELSE '' END
           || ObjectString_ToAddress.ValueData
             ) :: TVarChar            AS PartnerAddressAll_To
           , OH_JuridicalDetails_To.JuridicalId         AS JuridicalId_To
           , COALESCE (Object_ArticleLoss.ValueData, OH_JuridicalDetails_To.FullName) AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To
           , OH_JuridicalDetails_To.INN                 AS INN_To
           , OH_JuridicalDetails_To.NumberVAT           AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName       AS AccounterName_To
           , OH_JuridicalDetails_To.MainName            AS MainName_To
           , OH_JuridicalDetails_To.BankAccount         AS BankAccount_To
           , OH_JuridicalDetails_To.BankName            AS BankName_To
           , OH_JuridicalDetails_To.MFO                 AS BankMFO_To
           , OH_JuridicalDetails_To.Phone               AS Phone_To

           , COALESCE (OH_JuridicalDetails_Invoice.JuridicalId,      OH_JuridicalDetails_To.JuridicalId)         AS JuridicalId_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.FullName, COALESCE (Object_ArticleLoss.ValueData, OH_JuridicalDetails_To.FullName)) AS JuridicalName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.JuridicalAddress, OH_JuridicalDetails_To.JuridicalAddress)    AS JuridicalAddress_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.OKPO,             OH_JuridicalDetails_To.OKPO)                AS OKPO_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.INN,              OH_JuridicalDetails_To.INN)                 AS INN_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.NumberVAT,        OH_JuridicalDetails_To.NumberVAT)           AS NumberVAT_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.AccounterName,    OH_JuridicalDetails_To.AccounterName)       AS AccounterName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.MainName,         OH_JuridicalDetails_To.MainName)            AS MainName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.BankAccount,      OH_JuridicalDetails_To.BankAccount)         AS BankAccount_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.BankName,         OH_JuridicalDetails_To.BankName)            AS BankName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.MFO,              OH_JuridicalDetails_To.MFO)                 AS BankMFO_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.Phone,            OH_JuridicalDetails_To.Phone)               AS Phone_Invoice

           , CASE WHEN COALESCE (Object_PersonalCollation.ValueData, '') = '' THEN '' ELSE zfConvert_FIO (Object_PersonalCollation.ValueData, 2, FALSE) END :: TVarChar        AS PersonalCollationName
           --, CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId = 310855 /*�����*/ THEN ObjectString_Partner_GLNCode.ValueData ELSE ObjectString_Juridical_GLNCode.ValueData END AS BuyerGLNCode
           --, ObjectString_Partner_GLNCode.ValueData AS DeliveryPlaceGLNCode
           --, ObjectString_Partner_GLNCode.ValueData AS RecipientGLNCode

           , ObjectString_Partner_GLNCode.ValueData     AS DeliveryPlaceGLNCode
           /*, CASE WHEN ObjectString_Partner_GLNCodeJuridical.ValueData <> '' THEN ObjectString_Partner_GLNCodeJuridical.ValueData ELSE ObjectString_Juridical_GLNCode.ValueData END AS BuyerGLNCode
           , CASE WHEN ObjectString_Partner_GLNCodeRetail.ValueData <> '' THEN ObjectString_Partner_GLNCodeRetail.ValueData WHEN ObjectString_Retail_GLNCode.ValueData <> '' THEN ObjectString_Retail_GLNCode.ValueData ELSE ObjectString_Juridical_GLNCode.ValueData END AS RecipientGLNCode

           , CASE WHEN ObjectString_Partner_GLNCodeCorporate.ValueData <> '' THEN ObjectString_Partner_GLNCodeCorporate.ValueData ELSE ObjectString_JuridicalFrom_GLNCode.ValueData END AS SupplierGLNCode
           , CASE WHEN ObjectString_Partner_GLNCodeCorporate.ValueData <> '' THEN ObjectString_Partner_GLNCodeCorporate.ValueData ELSE ObjectString_JuridicalFrom_GLNCode.ValueData END AS SenderGLNCode*/

           , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                    , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                    , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                     ) AS BuyerGLNCode

           , zfCalc_GLNCodeRetail (inGLNCode               := ObjectString_Partner_GLNCode.ValueData
                                 , inGLNCodeRetail_partner := ObjectString_Partner_GLNCodeRetail.ValueData
                                 , inGLNCodeRetail         := ObjectString_Retail_GLNCode.ValueData
                                 , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode.ValueData
                                  ) AS RecipientGLNCode

           , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                    , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                     ) AS SupplierGLNCode

           , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                    , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                     ) AS SenderGLNCode

           , OH_JuridicalDetails_From.JuridicalId       AS JuridicalId_From
           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From
           , OH_JuridicalDetails_From.INN               AS INN_From
           , OH_JuridicalDetails_From.NumberVAT         AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName     AS AccounterName_From
           , CASE WHEN COALESCE (OH_JuridicalDetails_From.MainName, '') = '' THEN '' ELSE zfConvert_FIO (OH_JuridicalDetails_From.MainName, 2, FALSE) END :: TVarChar   AS MainName_From --- , zfConvert_FIO (OH_JuridicalDetails_From.MainName, 2, FALSE)          AS MainName_From
           , OH_JuridicalDetails_From.BankAccount       AS BankAccount_From
           , OH_JuridicalDetails_From.BankName          AS BankName_From
           , OH_JuridicalDetails_From.MFO               AS BankMFO_From
           , OH_JuridicalDetails_From.Phone             AS Phone_From
           --, ObjectString_JuridicalFrom_GLNCode.ValueData     AS SupplierGLNCode
           --, ObjectString_JuridicalFrom_GLNCode.ValueData     AS SenderGLNCode

           , Object_BankAccount.Name                            AS BankAccount_ByContract
           , '���������� ������' :: TVarChar                    AS CurrencyInternalAll_ByContract
           , Object_BankAccount.CurrencyInternalName            AS CurrencyInternal_ByContract
           , Object_BankAccount.BankName                        AS BankName_ByContract
           , Object_BankAccount.MFO                             AS BankMFO_ByContract
           , Object_BankAccount.SWIFT                           AS BankSWIFT_ByContract
           , Object_BankAccount.IBAN                            AS BankIBAN_ByContract
           , Object_BankAccount.CorrespondentBankName           AS CorrBankName_ByContract
           , Object_Bank_View_CorrespondentBank_From.SWIFT      AS CorrBankSWIFT_ByContract
           , Object_BankAccount.CorrespondentAccount            AS CorrespondentAccount_ByContract
           , OHS_JD_JuridicalAddress_Bank_From.ValueData        AS JuridicalAddressBankFrom
           , OHS_JD_JuridicalAddress_CorrBank_From.ValueData    AS JuridicalAddressCorrBankFrom


           , COALESCE(MovementLinkMovement_Sale.MovementChildId, 0)  AS EDIId

           , BankAccount_To.BankName                            AS BankName_Int
           , BankAccount_To.Name                                AS BankAccount_Int

           , BankAccount_To.CorrespondentBankName               AS CorBankName_Int
           , Object_Bank_View_CorrespondentBank.JuridicalName   AS CorBankJuridicalName_Int
           , Object_Bank_View_CorrespondentBank.SWIFT           AS CorBankSWIFT_Int

           , BankAccount_To.BeneficiarysBankName                AS BenefBankName_Int
           , OHS_JD_JuridicalAddress_BenifBank_To.ValueData     AS JuridicalAddressBenifBank_Int
           , Object_Bank_View_BenifBank.SWIFT                   AS BenifBankSWIFT_Int
           , BankAccount_To.BeneficiarysBankAccount             AS BenefBankAccount_Int

           , BankAccount_To.MFO                                 AS BankMFO_Int
           , BankAccount_To.SWIFT                               AS BankSWIFT_Int
           , BankAccount_To.IBAN                                AS BankIBAN_Int

           , Object_Bank_View_To.JuridicalName                  AS BankJuridicalName_Int
           , OHS_JD_JuridicalAddress_To.ValueData               AS BankJuridicalAddress_Int
           , BankAccount_To.BeneficiarysAccount                 AS BenefAccount_Int
           , BankAccount_To.Name                                AS BankAccount_Int

           , MS_InvNumberPartner_Master.ValueData               AS InvNumberPartner_Master

           , CASE WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                        THEN ' �� �������'
                  ELSE ''
             END AS Price_info

           , vbIsInfoMoney_30201 AS isInfoMoney_30201
           , vbIsInfoMoney_30200 AS isInfoMoney_30200

           , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '')
                  ELSE '' -- '�.��i���'
                  END  :: TVarChar   AS PlaceOf
           , CASE WHEN COALESCE (Object_Personal_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_Personal_View.PersonalName, 2, FALSE) ELSE '' END AS PersonalBookkeeperName   -- ��������� �� ���.�������

           , MovementSale_Comment.ValueData        AS SaleComment
           , CASE WHEN vbIsInfoMoney_30200 = FALSE AND TRIM (MovementOrder_Comment.ValueData) <> TRIM (COALESCE (MovementSale_Comment.ValueData, '')) THEN MovementOrder_Comment.ValueData ELSE '' END AS OrderComment
           , CASE WHEN Movement.DescId = zc_Movement_Loss() THEN TRUE ELSE FALSE END isMovementLoss

           , CASE WHEN Position(UPPER('�����') in UPPER(View_Contract.InvNumber)) > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPrintText

           , CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() THEN TRUE ELSE FALSE END :: Boolean AS isFirstForm

             -- ���-�� �����������
           , vbWeighingCount AS WeighingCount

       FROM Movement
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                           ON MovementLinkMovement_Sale.MovementId = Movement.Id
                                          AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_order
                                     ON MovementString_InvNumberPartner_order.MovementId =  Movement_order.Id
                                    AND MovementString_InvNumberPartner_order.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementString AS MovementSale_Comment
                                     ON MovementSale_Comment.MovementId = Movement.Id
                                    AND MovementSale_Comment.DescId = zc_MovementString_Comment()
            LEFT JOIN MovementString AS MovementOrder_Comment
                                     ON MovementOrder_Comment.MovementId = Movement_order.Id
                                    AND MovementOrder_Comment.DescId = zc_MovementString_Comment()


            LEFT JOIN MovementDate AS MovementDate_Payment
                                   ON MovementDate_Payment.MovementId =  Movement.Id
                                  AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                AND vbContractId = 0

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf
                                   ON ObjectString_PlaceOf.ObjectId = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                  AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()
            LEFT JOIN ObjectLink AS ObjectLink_Branch_Personal
                                 ON ObjectLink_Branch_Personal.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                AND ObjectLink_Branch_Personal.DescId = zc_ObjectLink_Branch_Personal()
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Branch_Personal.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalStore
                                 ON ObjectLink_Branch_PersonalStore.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                AND ObjectLink_Branch_PersonalStore.DescId = zc_ObjectLink_Branch_PersonalStore()
            LEFT JOIN Object_Personal_View AS Object_PersonalStore_View ON Object_PersonalStore_View.PersonalId = ObjectLink_Branch_PersonalStore.ChildObjectId



            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
            LEFT JOIN ObjectString AS ObjectString_Partner_ShortName
                                   ON ObjectString_Partner_ShortName.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_ShortName.DescId = zc_ObjectString_Partner_ShortName()
            LEFT JOIN Object_Partner_Address_View AS View_Partner_Address ON View_Partner_Address.PartnerId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
            LEFT JOIN ObjectString AS ObjectString_PostalCode
                                   ON ObjectString_PostalCode.ObjectId = View_Partner_Address.StreetId
                                  AND ObjectString_PostalCode.DescId = zc_ObjectString_Street_PostalCode()


            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())*/
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = vbPaidKindId -- MovementLinkObject_PaidKind.ObjectId
-- Contract
            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())*/
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'
            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                 ON ObjectLink_Contract_PersonalCollation.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
            LEFT JOIN Object AS Object_PersonalCollation ON Object_PersonalCollation.Id = ObjectLink_Contract_PersonalCollation.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalInvoice
                                 ON ObjectLink_Contract_JuridicalInvoice.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_JuridicalInvoice.DescId = zc_ObjectLink_Contract_JuridicalInvoice()
            -- ��� ����������
            LEFT JOIN ObjectString AS ObjectString_PartnerCode
                                   ON ObjectString_PartnerCode.ObjectId = View_Contract.ContractId
                                  AND ObjectString_PartnerCode.DescId = zc_objectString_Contract_PartnerCode()

            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = NULL

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCode
                                   ON ObjectString_Partner_GLNCode.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
         LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
                                ON ObjectString_Partner_GLNCodeJuridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                               AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
         LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeRetail
                                ON ObjectString_Partner_GLNCodeRetail.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                               AND ObjectString_Partner_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
         LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeCorporate
                                ON ObjectString_Partner_GLNCodeCorporate.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                               AND ObjectString_Partner_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_Invoice
                                                                ON OH_JuridicalDetails_Invoice.JuridicalId = ObjectLink_Contract_JuridicalInvoice.ChildObjectId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_Invoice.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_Invoice.EndDate

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                   ON ObjectString_Juridical_GLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode
                                   ON ObjectString_Retail_GLNCode.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                   ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId
                                                                                                        , COALESCE (View_Contract.JuridicalBasisId
                                                                                                        , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId
                                                                                                                  , Object_From.Id)))
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate
            LEFT JOIN ObjectString AS ObjectString_JuridicalFrom_GLNCode
                                   ON ObjectString_JuridicalFrom_GLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_JuridicalFrom_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

-- bank account
            LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                 ON ObjectLink_Contract_BankAccount.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()

            LEFT JOIN tmpBankAccount AS tmpBankAccount1 ON tmpBankAccount1.UnitId      = MovementLinkObject_From.ObjectId
                                                       AND tmpBankAccount1.InfoMoneyId = View_Contract.InfoMoneyId
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
            LEFT JOIN tmpBankAccount AS tmpBankAccount2 ON tmpBankAccount2.UnitId      = MovementLinkObject_From.ObjectId
                                                       AND tmpBankAccount2.InfoMoneyId = 0
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                       AND tmpBankAccount1.BankAccountId IS NULL
            LEFT JOIN tmpBankAccount AS tmpBankAccount3 ON tmpBankAccount3.UnitId      = 0
                                                       AND tmpBankAccount3.InfoMoneyId = View_Contract.InfoMoneyId
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                       AND tmpBankAccount1.BankAccountId IS NULL
                                                       AND tmpBankAccount2.BankAccountId IS NULL
            LEFT JOIN tmpBankAccount AS tmpBankAccount4 ON tmpBankAccount4.UnitId      = 0
                                                       AND tmpBankAccount4.InfoMoneyId = 0
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                       AND tmpBankAccount1.BankAccountId IS NULL
                                                       AND tmpBankAccount2.BankAccountId IS NULL
                                                       AND tmpBankAccount3.BankAccountId IS NULL
            LEFT JOIN Object_BankAccount_View AS Object_BankAccount ON Object_BankAccount.Id = COALESCE (ObjectLink_Contract_BankAccount.ChildObjectId, COALESCE (tmpBankAccount1.BankAccountId, COALESCE (tmpBankAccount2.BankAccountId, COALESCE (tmpBankAccount3.BankAccountId, tmpBankAccount4.BankAccountId))))

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_Bank_From
                                                                ON OH_JuridicalDetails_Bank_From.JuridicalId = Object_BankAccount.BankJuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_Bank_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_Bank_From.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_Bank_From
                                          ON OHS_JD_JuridicalAddress_Bank_From.ObjectHistoryId = OH_JuridicalDetails_Bank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_Bank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

            LEFT JOIN Object_Bank_View AS Object_Bank_View_CorrespondentBank_From ON Object_Bank_View_CorrespondentBank_From.Id = Object_BankAccount.CorrespondentBankId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_CorrBank_From
                                                                ON OH_JuridicalDetails_CorrBank_From.JuridicalId = Object_Bank_View_CorrespondentBank_From.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_CorrBank_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_CorrBank_From.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_CorrBank_From
                                          ON OHS_JD_JuridicalAddress_CorrBank_From.ObjectHistoryId = OH_JuridicalDetails_CorrBank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_CorrBank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

-- +++++++++++++++++ BANK TO
            LEFT JOIN
                      (SELECT *
                       FROM Object_BankAccount_View
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                    ON MovementLinkObject_To.MovementId = inMovementId
                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                            ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()


                      WHERE Object_BankAccount_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                      LIMIT 1
                      ) AS BankAccount_To ON 1=1

         LEFT JOIN Object_Bank_View AS Object_Bank_View_CorrespondentBank ON Object_Bank_View_CorrespondentBank.Id = BankAccount_To.CorrespondentBankId
         LEFT JOIN Object_Bank_View AS Object_Bank_View_BenifBank ON Object_Bank_View_BenifBank.Id = BankAccount_To.BeneficiarysBankId
         LEFT JOIN Object_Bank_View AS Object_Bank_View_To ON Object_Bank_View_To.Id = BankAccount_To.BankId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_BenifBank_To
                                                                ON OH_JuridicalDetails_BenifBank_To.JuridicalId = Object_Bank_View_BenifBank.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_BenifBank_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) < OH_JuridicalDetails_BenifBank_To.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_BenifBank_To
                                          ON OHS_JD_JuridicalAddress_BenifBank_To.ObjectHistoryId = OH_JuridicalDetails_BenifBank_To.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_BenifBank_To.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()


            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetailsBank_To
                                                                ON OH_JuridicalDetailsBank_To.JuridicalId = Object_Bank_View_To.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetailsBank_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetailsBank_To.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_To
                                          ON OHS_JD_JuridicalAddress_To.ObjectHistoryId = OH_JuridicalDetailsBank_To.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_To.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

--
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN MovementString AS MS_InvNumberPartner_Master ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                                                  AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()



       WHERE Movement.Id =  inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectFloat_AmountDoc.ValueData      AS AmountDoc
             , ObjectFloat_BoxCount.ValueData       AS BoxCount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()
             LEFT JOIN ObjectFloat AS ObjectFloat_AmountDoc
                                   ON ObjectFloat_AmountDoc.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_AmountDoc.DescId = zc_ObjectFloat_GoodsPropertyValue_AmountDoc()
             LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                   ON ObjectFloat_BoxCount.ObjectId = Object_GoodsPropertyValue.Id
                                  AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_GoodsPropertyValue_BoxCount()
             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Name
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.ArticleGLN
             , tmpObject_GoodsPropertyValue.BarCode
             , tmpObject_GoodsPropertyValue.BarCodeGLN
             , tmpObject_GoodsPropertyValue.BoxCount
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' OR ArticleGLN <> '' OR BarCode <> '' OR BarCodeGLN <> '' OR Name <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectString_BarCode.ValueData       AS BarCode
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           -- AND Object_GoodsPropertyValue.ValueData <> ''
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
       )
     , tmpMI_Order AS (SELECT MovementItem.ObjectId                         AS GoodsId
                            , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                            , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                            , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                       FROM (SELECT MovementLinkMovement_Order.MovementChildId AS MovementId
                             FROM MovementLinkMovement AS MovementLinkMovement_Order
                             WHERE MovementLinkMovement_Order.MovementId = inMovementId
                               AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                            ) AS tmpMovement
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                       GROUP BY MovementItem.ObjectId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())
                              , COALESCE (MIFloat_Price.ValueData, 0)
                              , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                         )
 -- ������ ���
 , tmpMI AS (SELECT MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                  , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE -- !!!��� ��� �� ���������, �� �� ������!!!
                              THEN CAST ( (1 + MIFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_Sale()
                              THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_Sale()
                              THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END AS Price
                  , MIFloat_CountForPrice.ValueData AS CountForPrice
                  , SUM (MovementItem.Amount) AS Amount
                  , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              WHEN Movement.DescId IN (zc_Movement_SendOnPrice()) AND vbIsProcess_BranchIn = TRUE
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              ELSE MovementItem.Amount

                         END) AS AmountPartner
                  , ObjectLink_GoodsGroup.ChildObjectId    AS GoodsGroupId

             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                              --AND MIFloat_Price.ValueData <> 0
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                              ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                       ON ObjectLink_GoodsGroup.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    , MIFloat_Price.ValueData
                    , MIFloat_CountForPrice.ValueData
                    , MIFloat_ChangePercent.ValueData
                    , ObjectLink_GoodsGroup.ChildObjectId
            )
      , tmpGoods AS (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
      , tmpUKTZED AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED (tmp.GoodsGroupId) AS CodeUKTZED
                      FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp
                     )
        -- ���� �� ������
      , tmpPriceList AS (SELECT lfSelect.GoodsId    AS GoodsId
                              , lfSelect.ValuePrice AS Price_basis
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                  , inOperDate   := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                                   ) AS lfSelect
                         WHERE lfSelect.ValuePrice <> 0
                        )
      -- ���������
      SELECT COALESCE (Object_GoodsByGoodsKind_View.Id, Object_Goods.Id) AS Id
           , Object_Goods.ObjectCode         AS GoodsCode
           , tmpObject_GoodsPropertyValue_basis.BarCode AS BarCode_Main

           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValueGroup.Name <> '' THEN tmpObject_GoodsPropertyValueGroup.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValueGroup.Name <> '' THEN tmpObject_GoodsPropertyValueGroup.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END) :: TVarChar AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , OS_Measure_InternalCode.ValueData  AS MeasureIntCode
           , CASE Object_Measure.Id
                  WHEN zc_Measure_Sh() THEN 'PCE'
                  ELSE 'KGM'
             END::TVarChar                   AS DELIVEREDUNIT
           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
           , tmpMI_Order.Amount              AS AmountOrder
           , tmpMI.Price                     AS Price
           , tmpMI.CountForPrice             AS CountForPrice

           , CASE WHEN COALESCE (tmpObject_GoodsPropertyValue.BoxCount, COALESCE (tmpObject_GoodsPropertyValueGroup.BoxCount, 0)) > 0
                       THEN CAST (tmpMI.AmountPartner / COALESCE (tmpObject_GoodsPropertyValue.BoxCount, COALESCE (tmpObject_GoodsPropertyValueGroup.BoxCount, 0)) AS NUMERIC (16, 4))
                  ELSE 0
             END AS AmountBox
           , CASE WHEN COALESCE (tmpObject_GoodsPropertyValue.AmountDoc, 0) > 0
                       THEN CAST ((tmpMI.AmountPartner / tmpObject_GoodsPropertyValue.AmountDoc) AS NUMERIC (16, 4))
                  ELSE 0
             END AS AmountDocBox

           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')       AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)      AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.AmountDoc, 0)   AS AmountDocInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BoxCount, COALESCE (tmpObject_GoodsPropertyValueGroup.BoxCount, 0))      AS BoxCount_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article,    COALESCE (tmpObject_GoodsPropertyValue.Article, ''))    AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode,    COALESCE (tmpObject_GoodsPropertyValue.BarCode, ''))    AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.ArticleGLN, COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '')) AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCodeGLN, COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '')) AS BarCodeGLN_Juridical

           , CASE WHEN vbGoodsPropertyId = 83954 -- �����
                       THEN COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, ''))
                  ELSE ''
             END AS Article_order

             -- ����� �� ����� ���-��
           , CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2))
             END AS AmountSumm

             -- ������ ���� ��� ���, �� 4 ������
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceNoVAT

             -- ������ ���� � ��� � �������, �� 4 ������
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (vbVATPercent / 100))
                                         * CASE WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = FALSE -- !!!��������� ��� ���, �� �� ������!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = FALSE -- !!!��������� ��� ���, �� �� ������!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * CASE WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = FALSE -- !!!��������� ��� ���, �� �� ������!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = FALSE -- !!!��������� ��� ���, �� �� ������!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT
             -- ������ ���� � ��� ��� ������, �� 4 ������
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (vbVATPercent / 100))
                                         * 1
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * 1
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT_original

             -- ������ ����� ��� ���, �� 2 ������
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT

             -- ������ ����� � ���, �� 3 ������
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) AS Amount_Weight
           , CAST (tmpMI.AmountPartner * COALESCE (ObjectFloat_Weight.ValueData, 0) AS TFloat) AS AmountPack_Weight
--           , CAST ((CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI.AmountPartner ELSE 0 END) AS TFloat) AS Amount_Sh


           , CASE WHEN vbOperDate < '01.01.2017'
                       THEN ''

                  WHEN ObjectString_Goods_UKTZED.ValueData <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED.ValueData FROM 1 FOR 4) END

                  WHEN tmpUKTZED.CodeUKTZED <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN tmpUKTZED.CodeUKTZED ELSE SUBSTRING (tmpUKTZED.CodeUKTZED FROM 1 FOR 4) END

                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101())
                       THEN '1601'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_30102())
                       THEN '1602'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30103()
                       THEN '1905'
                  ELSE '0'
              END :: TVarChar AS GoodsCodeUKTZED

              -- ��������� ���� ��� ���, ���
            , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20501() AND tmpPriceList.Price_basis > 0 THEN tmpPriceList.Price_basis
                   WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20501() THEN 60
                   ELSE 0
              END :: TFloat AS Price_Pledge
            , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20501() -- ������������� + "��������� ����"
                        THEN TRUE
                   ELSE FALSE
              END :: Boolean AS isFozziTare
       FROM tmpMI
            LEFT JOIN tmpUKTZED ON tmpUKTZED.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpMI_Order ON tmpMI_Order.GoodsId     = tmpMI.GoodsId
                                 AND tmpMI_Order.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            LEFT JOIN ObjectString AS OS_Measure_InternalCode
                                   ON OS_Measure_InternalCode.ObjectId = Object_Measure.Id
                                  AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
                                                  AND (tmpObject_GoodsPropertyValue.Article <> ''
                                                    OR tmpObject_GoodsPropertyValue.BarCode <> ''
                                                    OR tmpObject_GoodsPropertyValue.ArticleGLN <> ''
                                                    OR tmpObject_GoodsPropertyValue.Name <> '')
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                  AND Object_GoodsByGoodsKind_View.GoodsKindId = Object_GoodsKind.Id
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()

            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpMI.GoodsId

       WHERE tmpMI.AmountPartner <> 0
       ORDER BY CASE WHEN vbGoodsPropertyId IN (83954  -- �����
                                              , 83963  -- ����
                                              , 404076 -- �����
                                               )
                          THEN zfConvert_StringToNumber (COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '0')))
                     ELSE '0'
                END :: Integer
              , Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

    RETURN NEXT Cursor2;

    -- ������ ����
    OPEN Cursor3 FOR
      SELECT Object_Goods.ObjectCode         AS GoodsCode
           , (Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , Object_Goods.ValueData          AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 0 END )) AS TFloat) AS Amount_Weight
           -- , CAST ((CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI.AmountPartner ELSE 0 END) AS TFloat) AS Amount_Sh

       FROM (SELECT MovementItem.ObjectId                         AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , SUM (MovementItem.Amount) AS Amount
                  , SUM (MovementItem.Amount) AS AmountPartner
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
               AND COALESCE (MIFloat_Price.ValueData, 0) = 0
               AND 1 = 0 -- !!!�������� ��������!!!
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
            ) AS tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       WHERE tmpMI.AmountPartner <> 0

       ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData
      ;

    RETURN NEXT Cursor3;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.11.15         *
 17.09.15         *
 13.11.14                                                       * fix
 12.11.14                                        * add AmountOrder
 17.10.14                                                       *
 13.05.14                                                       * Amount_Weight Amount_Sh
 23.07.14                                        * add ArticleGLN
 16.07.14                                        * add tmpObject_GoodsPropertyValueGroup
 20.06.14                                                       * change InvNumber
 05.06.14                                        * restore ContractSigningDate
 04.06.14                                        * add tmpObject_GoodsPropertyValue.Name
 20.05.14                                        * add Object_Contract_View
 17.05.14                                        * add StatusId = zc_Enum_Status_Complete
 13.05.14                                        * add calc GoodsName
 13.05.14                                                       * zc_ObjectLink_Contract_BankAccount
 08.05.14                        * add GLN code
 08.05.14                                        * all
 06.05.14                                        * add Object_Partner
 06.05.14                                                       * zc_Movement_SendOnPrice
 06.05.14                                        * OperDatePartner
 05.05.14                                                       *
 28.04.14                                                       *
 09.04.14                                        * add JOIN MIFloat_AmountPartner
 02.04.14                                                       *  PriceWVAT PriceNoVAT round to 2 sign
 01.04.14                                                       *  tmpMI.Price <> 0
 27.03.14                                                       *
 24.02.14                                                       *  add PriceNoVAT, PriceWVAT, AmountSummNoVAT, AmountSummWVAT
 19.02.14                                                       *  add by juridical
 07.02.14                                                       *  change to Cursor
 05.02.14                                                       *
*/

/*
-- PrintMovement_Sale01074874.fr3
++ PrintMovement_Sale1.fr3
++ PrintMovement_Sale2.fr3
-- PrintMovement_Sale22447463.fr3
++ PrintMovement_Sale2DiscountPrice.fr3
-- PrintMovement_Sale30487219.fr3
++ PrintMovement_Sale30982361.fr3
++ PrintMovement_Sale31929492.fr3
++ PrintMovement_Sale32049199.fr3
++ PrintMovement_Sale32294926.fr3
-- PrintMovement_Sale32516492.fr3
-- PrintMovement_Sale35275230.fr3
++ PrintMovement_Sale35442481.fr3
++ PrintMovement_Sale36003603.fr3
++ PrintMovement_Sale36387249.fr3
-- PrintMovement_Sale37910513.fr3
++ PrintMovement_Sale39118745.fr3


++ PrintMovement_Transport.fr3
++ PrintMovement_Transport32049199.fr3
-- PrintMovement_Transport32516492.fr3
++ PrintMovement_Transport36003603.fr3
*/
-- ����
-- SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId:= 4115668 , inSession:= zfCalc_UserAdmin()); -- FETCH ALL "<unnamed portal 1>";
