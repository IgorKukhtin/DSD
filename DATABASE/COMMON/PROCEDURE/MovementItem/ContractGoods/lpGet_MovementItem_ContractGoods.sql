-- Function: lpGet_MovementItem_ContractGoods()

DROP FUNCTION IF EXISTS lpGet_MovementItem_ContractGoods (TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpGet_MovementItem_ContractGoods (TDateTime, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_MovementItem_ContractGoods(
    IN inOperDate           TDateTime , -- ���� ��������
    IN inJuridicalId        Integer   , --
    IN inPartnerId          Integer   , --
    IN inContractId         Integer   , --
    IN inGoodsId            Integer   , --
    IN inUserId             Integer     --
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, isPriceWithVAT Boolean, isMultWithVAT Boolean
             , MovementItemId Integer, GoodsId Integer, GoodsCode Integer, GoodsKindId Integer

               -- ���� �� ������������ � ��� - � ������ ����� � ����������
             , ValuePrice TFloat
               -- ���� ��� ���
             , ValuePrice_notVat TFloat
               -- ���� � ���
             , ValuePrice_addVat TFloat

               -- ���� ������������ - �������� (� ������)
             , ValuePrice_orig     TFloat
               -- ���� � ��� - �� �����, ���� ��� ���+��������� ��� ��� ����������
             , ValuePrice_GRN      TFloat

               -- ���-�� ������ ��� ����������
             , RoundPrice TFloat
               -- % ������ ��� ����
             , ChangePercent_price TFloat
               -- ����������� % ���������� ��� ����
             , DiffPrice TFloat
               -- ����� �������� �� ���-�� ����������
             , CountForAmount TFloat

               -- ����� ��������� ���� � ��� - � ������ ����� � ����������
             , ValuePrice_from TFloat
               -- ���� ��������� ���� � ��� - � ������ ����� � ����������
             , ValuePrice_to TFloat

               -- ����� ��������� ����
             , ValuePrice_from_notVat TFloat
               -- ���� ��������� ����
             , ValuePrice_to_notVat TFloat

               -- ����� ��������� ����
             , ValuePrice_from_addVat TFloat
               -- ���� ��������� ����
             , ValuePrice_to_addVat TFloat

               --
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
              )
AS
$BODY$
  DECLARE vbCurrency        TFloat;
  DECLARE vbParValue        TFloat;
BEGIN

    -- RAISE EXCEPTION '������.<%>   <%>    <%>    <%>', inJuridicalId, inPartnerId, inContractId, inGoodsId;

       -- �������� ������
       RETURN QUERY
         WITH -- ����� ����� ��� ��������
              tmpCurrencyList_all AS (SELECT Movement.OperDate
                                           , Movement.Id AS MovementId
                                             -- ��������� ����
                                           , COALESCE (MLO_SiteTag.ObjectId, 0) AS SiteTagId
                                      FROM Movement
                                           LEFT JOIN MovementLinkObject AS MLO_SiteTag
                                                                        ON MLO_SiteTag.MovementId = Movement.Id
                                                                       AND MLO_SiteTag.DescId     = zc_MovementLinkObject_SiteTag()
                                      WHERE Movement.DescId   = zc_Movement_CurrencyList()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                        -- �� ���� ���� ������
                                        AND Movement.OperDate < inOperDate
                                     )
            , tmpCurrencyMI AS (SELECT * FROM MovementItem WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpCurrencyList_all.MovementId FROM tmpCurrencyList_all))
            , tmpCurrencyList AS (SELECT tmpCurrencyList_all.OperDate
                                       , MILinkObject_Currency.ObjectId AS CurrencyId
                                       , MovementItem.ObjectId          AS CurrencyId_value
                                       , MovementItem.Amount            AS CurrencyValue
                                       , MIFloat_ParValue.ValueData     AS ParValue
                                       , MILinkObject_PaidKind.ObjectId AS PaidKindId
                                         -- ��������� ����
                                       , tmpCurrencyList_all.SiteTagId
                                         -- � �/�
                                       , ROW_NUMBER() OVER (PARTITION BY MILinkObject_Currency.ObjectId, MILinkObject_PaidKind.ObjectId, tmpCurrencyList_all.SiteTagId ORDER BY tmpCurrencyList_all.OperDate DESC) AS Ord
                                  FROM tmpCurrencyList_all
                                       LEFT JOIN tmpCurrencyMI AS MovementItem ON MovementItem.MovementId = tmpCurrencyList_all.MovementId
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                       LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                                   ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                        ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                        ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_PaidKind.DescId         = zc_MILinkObject_PaidKind()

                                  WHERE tmpCurrencyList_all.OperDate < inOperDate
                                 )
              --
            , tmpData AS (SELECT Movement.Id                                    AS MovementId
                               , Movement.InvNumber                             AS InvNumber
                               , Movement.OperDate                              AS OperDate
                               , CASE WHEN inUserId=5 AND 1=0
                                           THEN FALSE
                                      ELSE COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)
                                 END AS isPriceWithVAT

                               , COALESCE (MovementBoolean_MultWithVAT.ValueData, FALSE)  AS isMultWithVAT
                               , MLO_Contract.ObjectId                          AS ContractId
                               , ObjectLink_Contract_Juridical.ChildObjectId    AS JuridicalId
                               , MLO_Currency.ObjectId                          AS CurrencyId
                               , ObjectLink_Contract_PaidKind.ChildObjectId     AS PaidKindId
                                 -- ��������� ����
                               , COALESCE (MLO_SiteTag.ObjectId, 0)             AS SiteTagId

                               , MovementItem.Id                                AS MovementItemId
                               , MovementItem.ObjectId                          AS GoodsId
                               , Object_Goods.ObjectCode                        AS GoodsCode
                               , Object_Goods.ValueData                         AS GoodsName
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId

                                 -- ���� � ��� - �� �����
                               , CASE
                                      -- ���� ����� ���������
                                      WHEN MovementBoolean_MultWithVAT.ValueData = TRUE
                                       -- + ��� ���
                                       AND COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) = FALSE
                                           -- ������ 5
                                           THEN ROUND (COALESCE (MIF_Price.ValueData, 0) / CASE WHEN MIF_CountForPrice.ValueData > 0 THEN MIF_CountForPrice.ValueData ELSE 1 END
                                                       -- % ������
                                                     * (1 + COALESCE (MIF_ChangePercent.ValueData, 0) / 100)
                                                       -- ����
                                                     * CASE WHEN COALESCE (MLO_Currency.ObjectId, 0) IN (0, zc_Enum_Currency_Basis()) THEN 1
                                                            WHEN tmpCurrencyList.CurrencyValue > 0 AND tmpCurrencyList.ParValue > 0 THEN tmpCurrencyList.CurrencyValue / tmpCurrencyList.ParValue
                                                            WHEN tmpCurrencyList.CurrencyValue > 0 THEN tmpCurrencyList.CurrencyValue
                                                            ELSE 0
                                                       END / 5 * 100
                                                      ) * 5 / 100

                                      -- ���� ������ ��������� �� ����� - ��� ����������
                                      ELSE COALESCE (MIF_Price.ValueData, 0) / CASE WHEN MIF_CountForPrice.ValueData > 0 THEN MIF_CountForPrice.ValueData ELSE 1 END
                                           -- % ������
                                         * (1 + COALESCE (MIF_ChangePercent.ValueData, 0) / 100)
                                           -- ����
                                         * CASE WHEN COALESCE (MLO_Currency.ObjectId, 0) IN (0, zc_Enum_Currency_Basis()) THEN 1
                                                WHEN tmpCurrencyList.CurrencyValue > 0 AND tmpCurrencyList.ParValue > 0 THEN tmpCurrencyList.CurrencyValue / tmpCurrencyList.ParValue
                                                WHEN tmpCurrencyList.CurrencyValue > 0 THEN tmpCurrencyList.CurrencyValue
                                                ELSE 0
                                           END
                                 END AS ValuePrice_GRN

                                 -- ???���� ��� ���???
                               , CASE WHEN COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) = FALSE
                                           THEN COALESCE (MIF_Price.ValueData, 0) / CASE WHEN MIF_CountForPrice.ValueData > 0 THEN MIF_CountForPrice.ValueData ELSE 1 END
                                      -- ���� ������ ��������� �� ����� - ��� ����������
                                      ELSE CAST (COALESCE (MIF_Price.ValueData, 0) / 1.2 / CASE WHEN MIF_CountForPrice.ValueData > 0 THEN MIF_CountForPrice.ValueData ELSE 1 END AS NUMERIC (16, 4))
                                 END AS ValuePrice_orig_notVat

                                 --
                               , COALESCE (MIF_Price.ValueData, 0)              AS ValuePrice_orig
                               , COALESCE (MIF_CountForPrice.ValueData, 0)      AS CountForPrice

                                 -- % ������ ��� ����
                               , COALESCE (MIF_ChangePercent.ValueData, 0)      AS ChangePercent_price

                                 -- ����� �������� �� ���-�� ����������
                               , CASE WHEN MIF_CountForAmount.ValueData > 0 THEN MIF_CountForAmount.ValueData ELSE 1 END AS CountForAmount
                                 -- ����������� % ���������� ��� ����
                               , COALESCE (MFloat_DiffPrice.ValueData, 0)       AS DiffPrice
                                 -- ���-�� ������ ��� ����������
                               , CASE WHEN inUserId=5 AND 1=0
                                           THEN 4
                                      ELSE COALESCE (MFloat_RoundPrice.ValueData, 0)
                                 END AS RoundPrice
                                 --
                               , tmpCurrencyList.CurrencyValue
                               , tmpCurrencyList.ParValue
                                 -- � �/�
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                          FROM Movement

                               INNER JOIN MovementLinkObject AS MLO_Contract
                                                             ON MLO_Contract.MovementId = Movement.Id
                                                            AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                            AND (MLO_Contract.ObjectId  = inContractId OR COALESCE (inContractId, 0) = 0)
                               LEFT JOIN MovementLinkObject AS MLO_SiteTag
                                                            ON MLO_SiteTag.MovementId = Movement.Id
                                                           AND MLO_SiteTag.DescId     = zc_MovementLinkObject_SiteTag()

                               LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                         ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                                        AND MovementBoolean_PriceWithVAT.DescId     = zc_MovementBoolean_PriceWithVAT()
                               LEFT JOIN MovementBoolean AS MovementBoolean_MultWithVAT
                                                         ON MovementBoolean_MultWithVAT.MovementId = Movement.Id
                                                        AND MovementBoolean_MultWithVAT.DescId     = zc_MovementBoolean_MultWithVAT()
                               LEFT JOIN MovementLinkObject AS MLO_Currency
                                                            ON MLO_Currency.MovementId = Movement.Id
                                                           AND MLO_Currency.DescId     = zc_MovementLinkObject_Currency()
                               LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                    ON ObjectLink_Contract_Juridical.ObjectId = MLO_Contract.ObjectId
                                                   AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                               LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                                    ON ObjectLink_Contract_PaidKind.ObjectId = MLO_Contract.ObjectId
                                                   AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                                                      AND (MovementItem.ObjectId  = inGoodsId OR COALESCE (inGoodsId, 0) = 0)

                               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                               LEFT JOIN MovementItemFloat AS MIF_Price
                                                           ON MIF_Price.MovementItemId = MovementItem.Id
                                                          AND MIF_Price.DescId         = zc_MIFloat_Price()
                               LEFT JOIN MovementItemFloat AS MIF_CountForPrice
                                                           ON MIF_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIF_CountForPrice.DescId         = zc_MIFloat_CountForPrice()

                               -- % ������
                               LEFT JOIN MovementItemFloat AS MIF_ChangePercent
                                                           ON MIF_ChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIF_ChangePercent.DescId         = zc_MIFloat_ChangePercent()

                               -- ����� �������� �� ���-�� ����������
                               LEFT JOIN MovementItemFloat AS MIF_CountForAmount
                                                           ON MIF_CountForAmount.MovementItemId = MovementItem.Id
                                                          AND MIF_CountForAmount.DescId         = zc_MIFloat_CountForAmount()
                               -- ����������� % ���������� ��� ����
                               LEFT JOIN MovementFloat AS MFloat_DiffPrice
                                                       ON MFloat_DiffPrice.MovementId = Movement.Id
                                                      AND MFloat_DiffPrice.DescId     = zc_MovementFloat_DiffPrice()
                               -- ���-�� ������ ��� ����������
                               LEFT JOIN MovementFloat AS MFloat_RoundPrice
                                                       ON MFloat_RoundPrice.MovementId = Movement.Id
                                                      AND MFloat_RoundPrice.DescId     = zc_MovementFloat_RoundPrice()

                               LEFT JOIN tmpCurrencyList ON tmpCurrencyList.CurrencyId = MLO_Currency.ObjectId
                                                        AND tmpCurrencyList.PaidKindId = ObjectLink_Contract_PaidKind.ChildObjectId
                                                        AND tmpCurrencyList.SiteTagId  = COALESCE (MLO_SiteTag.ObjectId, 0)
                                                        AND tmpCurrencyList.Ord        = 1

                          WHERE Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '36 MONTH') AND inOperDate
                            AND Movement.DescId    = zc_Movement_ContractGoods()
                            AND Movement.StatusId  = zc_Enum_Status_Complete()
                            AND (ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                         )
         -- ���������
         SELECT tmpData.MovementId
              , tmpData.InvNumber
              , tmpData.OperDate
              , tmpData.isPriceWithVAT
              , tmpData.isMultWithVAT
              , tmpData.MovementItemId
              , tmpData.GoodsId
              , tmpData.GoodsCode
              , tmpData.GoodsKindId

                -- ���� �� ������������
              , CASE WHEN tmpData.isPriceWithVAT = FALSE
                          THEN tmpData.ValuePrice_notVat
                     WHEN tmpData.isPriceWithVAT = TRUE
                          THEN tmpData.ValuePrice_addVat
                     ELSE tmpData.ValuePrice
                END :: TFloat
                -- ���� ��� ��� / 1.2
              , tmpData.ValuePrice_notVat :: TFloat AS ValuePrice_notVat
                -- ���� � ��� * 1.2
              , tmpData.ValuePrice_addVat :: TFloat AS ValuePrice_addVat

                -- ���� �� ������������ - �������� (� ������)
              , tmpData.ValuePrice_orig :: TFloat
                -- ���� � ��� - �� �����, ���� ��� ���+��������� ��� ��� ����������
              , tmpData.ValuePrice_GRN  :: TFloat

               -- ���-�� ������ ��� ����������
              , tmpData.RoundPrice          :: TFloat
               -- % ������ ��� ����
              , tmpData.ChangePercent_price :: TFloat
                -- ����������� % ���������� ��� ����
              , tmpData.DiffPrice           :: TFloat
                -- ����� �������� �� ���-�� ����������
              , tmpData.CountForAmount      :: TFloat

                -- ���� �� ������������ - ��
              , (CASE WHEN tmpData.isPriceWithVAT = FALSE
                          THEN tmpData.ValuePrice_notVat
                     WHEN tmpData.isPriceWithVAT = TRUE
                          THEN tmpData.ValuePrice_addVat
                     ELSE tmpData.ValuePrice
                 END * (1 - tmpData.DiffPrice / 100)) :: TFloat
                -- ���� �� ������������ - ��
              , (CASE WHEN tmpData.isPriceWithVAT = FALSE
                          THEN tmpData.ValuePrice_notVat
                     WHEN tmpData.isPriceWithVAT = TRUE
                          THEN tmpData.ValuePrice_addVat
                     ELSE tmpData.ValuePrice
                 END * (1 + tmpData.DiffPrice / 100)) :: TFloat

                -- ��� ��� ����� ��������� ����
              , (tmpData.ValuePrice_notVat * (1 - tmpData.DiffPrice / 100)) :: TFloat AS ValuePrice_from_notVat
                -- ��� ��� ���� ��������� ����
              , (tmpData.ValuePrice_notVat * (1 + tmpData.DiffPrice / 100)) :: TFloat AS ValuePrice_to_notVat

                -- � ��� ����� ��������� ����
              , (tmpData.ValuePrice_addVat * (1 - tmpData.DiffPrice / 100)) :: TFloat AS ValuePrice_from_addVat
                -- � ��� ���� ��������� ����
              , (tmpData.ValuePrice_addVat * (1 + tmpData.DiffPrice / 100)) :: TFloat AS ValuePrice_to_addVat

              , tmpData.JuridicalId                         AS JuridicalId
              , Object_Juridical.ValueData                  AS JuridicalName
              , tmpData.ContractId                          AS ContractId
              , Object_Contract_InvNumber_View.ContractCode AS ContractCode
              , Object_Contract_InvNumber_View.InvNumber    AS ContractName
              , tmpData.PaidKindId                          AS PaidKindId
              , Object_PaidKind.ValueData                   AS PaidKindName
              , tmpData.CurrencyId                          AS CurrencyId
              , Object_Currency.ValueData                   AS CurrencyName
              , tmpData.CurrencyValue
              , tmpData.ParValue


         FROM  (SELECT tmpData.MovementId
                     , tmpData.InvNumber
                     , tmpData.OperDate
                     , tmpData.isPriceWithVAT
                     , tmpData.isMultWithVAT
                     , tmpData.MovementItemId
                     , tmpData.GoodsId
                     , tmpData.GoodsCode
                     , tmpData.GoodsKindId

                       -- ���� � ��� - �� �����, ���� ��� ���+��������� ��� ��� ����������
                     , tmpData.ValuePrice_GRN
                     , tmpData.ValuePrice_orig  AS ValuePrice_orig

                     , tmpData.RoundPrice
                     , tmpData.ChangePercent_price
                     , tmpData.DiffPrice
                     , tmpData.CountForAmount

                       -- ���� �� ������������ - � ��� + ���������� (�� ���� �����)
                     , tmpData.ValuePrice

                       -- ���� ��� ��� / 1.2
                     , CASE WHEN tmpData.isPriceWithVAT = FALSE AND COALESCE (tmpData.CurrencyId, 0) IN (0, zc_Enum_Currency_Basis())
                                 -- ��� ��� ���, ������ �� ������
                                 THEN tmpData.ValuePrice

                            -- ��� ��� ���
                            WHEN tmpData.isPriceWithVAT = FALSE
                                 THEN tmpData.ValuePrice

                            -- ������� ��� ��� + ���������
                            WHEN tmpData.RoundPrice = 0 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 1) * 5 / 1

                            WHEN tmpData.RoundPrice = 1 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 10) * 5 / 10

                            WHEN tmpData.RoundPrice = 2 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 100) * 5 / 100

                            WHEN tmpData.RoundPrice = 3 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 1000) * 5 / 1000

                            WHEN tmpData.RoundPrice = 4 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 10000) * 5 / 10000

                            -- ����� 2 ����� + ���������
                            WHEN tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 100) * 5 / 100

                            -- ������� ��� ��� + ����������
                            WHEN tmpData.RoundPrice = 1
                                 THEN CAST (tmpData.ValuePrice / 1.2 AS NUMERIC (16, 1))
                            WHEN tmpData.RoundPrice = 2 OR tmpData.RoundPrice = 0
                                 THEN CAST (tmpData.ValuePrice / 1.2 AS NUMERIC (16, 2))
                            WHEN tmpData.RoundPrice = 3
                                 THEN CAST (tmpData.ValuePrice / 1.2 AS NUMERIC (16, 3))
                            WHEN tmpData.RoundPrice = 4
                                 THEN CAST (tmpData.ValuePrice / 1.2 AS NUMERIC (16, 4))

                            -- ����� 2 �����
                            ELSE CAST (tmpData.ValuePrice / 1.2 AS NUMERIC (16, 2))

                       END :: TFloat AS ValuePrice_notVat

                       -- ���� � ��� * 1.2
                     , CASE WHEN tmpData.isPriceWithVAT = TRUE AND COALESCE (tmpData.CurrencyId, 0) IN (0, zc_Enum_Currency_Basis())
                                 -- ��� � ���, ������ �� ������
                                 THEN tmpData.ValuePrice

                            -- ������� ��� ��� + ��������� + � ���
                            WHEN tmpData.RoundPrice = 0 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 1) * 5 / 1 * 1.2

                            -- ������� ��� ��� + ��������� + � ���
                            WHEN tmpData.RoundPrice = 1 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 10) * 5 / 10 * 1.2

                            -- ������� ��� ��� + ��������� + � ���
                            WHEN tmpData.RoundPrice = 2 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 100) * 5 / 100 * 1.2

                            -- ������� ��� ��� + ��������� + � ���
                            WHEN tmpData.RoundPrice = 3 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 1000) * 5 / 1000 * 1.2

                            -- ������� ��� ��� + ��������� + � ���
                            WHEN tmpData.RoundPrice = 4 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 10000) * 5 / 10000 * 1.2

                            -- ����� ��� ��� 2 ����� + ��������� + � ���
                            WHEN tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 100) * 5 / 100 * 1.2

                            -- ��� � ���
                            WHEN tmpData.isPriceWithVAT = TRUE
                                 THEN tmpData.ValuePrice

                            -- ������� � ��� + ����������
                            WHEN tmpData.RoundPrice = 1
                                 THEN CAST (tmpData.ValuePrice * 1.2 AS NUMERIC (16, 1))
                            WHEN tmpData.RoundPrice = 2 OR tmpData.RoundPrice = 0
                                 THEN CAST (tmpData.ValuePrice * 1.2 AS NUMERIC (16, 2))
                            WHEN tmpData.RoundPrice = 3
                                 THEN CAST (tmpData.ValuePrice * 1.2 AS NUMERIC (16, 3))
                            WHEN tmpData.RoundPrice = 4
                                 THEN CAST (tmpData.ValuePrice * 1.2 AS NUMERIC (16, 4))

                            ELSE CAST (tmpData.ValuePrice * 1.2 AS NUMERIC (16, 2))

                       END :: TFloat AS ValuePrice_addVat

                     , tmpData.JuridicalId
                     , tmpData.ContractId
                     , tmpData.PaidKindId
                     , tmpData.CurrencyId
                     , tmpData.CurrencyValue
                     , tmpData.ParValue

                FROM
               (SELECT tmpData.MovementId
                     , tmpData.InvNumber
                     , tmpData.OperDate
                     , tmpData.isPriceWithVAT
                     , tmpData.isMultWithVAT
                     , tmpData.MovementItemId
                     , tmpData.GoodsId
                     , tmpData.GoodsCode
                     , tmpData.GoodsKindId
                       -- ���� � ��� - �� �����, ���� ��� ���+��������� ��� ��� ����������
                     , tmpData.ValuePrice_GRN

                       -- ���� �� ������������ - � ��� + ���������� (�� ���� �����)
                     , (CASE WHEN COALESCE (tmpData.CurrencyId, 0) IN (0, zc_Enum_Currency_Basis())
                                  -- ��� ����������
                                  THEN tmpData.ValuePrice_GRN

                             -- ���� ���������
                             WHEN tmpData.isMultWithVAT = TRUE
                                  -- ��� ����������
                                  THEN tmpData.ValuePrice_GRN

                             WHEN tmpData.RoundPrice = 1
                                  -- ����������
                                  THEN CAST (tmpData.ValuePrice_GRN AS NUMERIC (16, 1))
                             WHEN tmpData.RoundPrice = 2 OR tmpData.RoundPrice = 0
                                  -- ����������
                                  THEN CAST (tmpData.ValuePrice_GRN AS NUMERIC (16, 2))
                             WHEN tmpData.RoundPrice = 3
                                  -- ����������
                                  THEN CAST (tmpData.ValuePrice_GRN AS NUMERIC (16, 3))
                             WHEN tmpData.RoundPrice = 4
                                  -- ����������
                                  THEN CAST (tmpData.ValuePrice_GRN AS NUMERIC (16, 4))

                             -- ����������
                             ELSE CAST (tmpData.ValuePrice_GRN AS NUMERIC (16, 2))

                        END) AS ValuePrice


                     , tmpData.ValuePrice_orig  AS ValuePrice_orig

                     , tmpData.RoundPrice
                     , tmpData.ChangePercent_price
                     , tmpData.DiffPrice
                     , tmpData.CountForAmount

                     , tmpData.JuridicalId
                     , tmpData.ContractId
                     , tmpData.PaidKindId
                     , tmpData.CurrencyId
                     , tmpData.CurrencyValue
                     , tmpData.ParValue

                FROM tmpData

                WHERE tmpData.Ord = 1
               ) AS tmpData

               ) AS tmpData

               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
               LEFT JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = tmpData.ContractId
               LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId
               LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = tmpData.CurrencyId
              ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.04.22                                        *
*/

-- ����
-- SELECT * FROM lpGet_MovementItem_ContractGoods (inOperDate:= '22.11.2024', inJuridicalId:=0, inPartnerId:= 0, inContractId:= 10485535, inGoodsId:= 0, inUserId:= 5)
