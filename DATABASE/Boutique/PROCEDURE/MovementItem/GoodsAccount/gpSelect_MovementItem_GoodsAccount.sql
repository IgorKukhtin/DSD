-- Function: gpSelect_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_GoodsAccount (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_GoodsAccount(
    IN inMovementId       Integer      , -- ���� ���������
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, PartionId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , CompositionGroupName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeName TVarChar

             , Amount TFloat, Amount_Sale TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat
               -- ����� ����� ��. + ����� (� ����.)
             , TotalSumm TFloat, TotalSummPriceList TFloat

               -- ���� ��� �������� �� ������ ������ � ���
             , CurrencyValue TFloat, ParValue TFloat

               -- ����� ����� ������ - ��� "��������" ��������� �������
             , TotalPay_Sale TFloat
               -- ����� ����� ������ - ��� "������� �����������"
             , TotalPayOth_Sale TFloat

               -- ��������
             , Amount_Return TFloat, TotalReturn TFloat, TotalPay_Return TFloat
               -- ����
             , SummDebt TFloat
               -- % ������
             , ChangePercent TFloat
               -- ����� ����� ������ - ��� "��������" ��������� �������: 2)��������������
             , SummChangePercent_sale TFloat
               -- ����� ����� ������ - ��� "��������" ��������� �������: 1)�� %������
             , TotalChangePercent_sale TFloat
               -- ����� ����� ������ - ��� "������� �����������"
             , TotalChangePercentPay TFloat

             , TotalSummToPay TFloat
             , TotalPay_Grn TFloat, TotalPay_USD TFloat, TotalPay_Eur TFloat, TotalPay_Card TFloat
             , TotalPay TFloat, SummChangePercent TFloat

             , Amount_USD_Exc    TFloat
             , Amount_EUR_Exc    TFloat
             , Amount_GRN_Exc    TFloat

             , SaleMI_Id Integer
             , MovementId_Sale Integer, InvNumber_Sale_Full TVarChar
             , OperDate_Sale TDateTime , DescName TVarChar
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId   Integer;

  DECLARE vbStatusId Integer;
  DECLARE vbUnitId   Integer;
  DECLARE vbClientId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_GoodsAccount());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� ���������
     SELECT Movement.StatusId                AS StatusId
          , MovementLinkObject_From.ObjectId AS ClientId
          , MovementLinkObject_To.ObjectId   AS UnitId
            INTO vbStatusId, vbClientId, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;



     IF inShowAll = TRUE
     THEN
     -- ��������� �����
     RETURN QUERY
     WITH
         tmpMI_Sale AS (-- ������� ����������
                        SELECT Movement.Id                                        AS MovementId
                             , Movement.DescId                                    AS DescId
                             , Movement.OperDate                                  AS OperDate
                             , Movement.InvNumber                                 AS InvNumber
                             , MovementItem.Id                                    AS SaleMI_Id
                             , MovementItem.PartionId                             AS PartionId
                             , MovementItem.ObjectId                              AS GoodsId
                             , MovementItem.Amount                                AS Amount
                             , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList

                               -- ����� ����� ������ - ��� "��������" ��������� �������
                             , COALESCE (MIFloat_TotalPay.ValueData, 0)           AS TotalPay
                               -- ����� ����� ������ - ��� "������� �����������"
                             , COALESCE (MIFloat_TotalPayOth.ValueData, 0)        AS TotalPayOth

                               -- ����� ���������� �������� - ��� ���-��
                             , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)   AS Amount_Return
                               -- ����� ����� �������� �� �������  - ��� ���-��
                             , COALESCE (MIFloat_TotalReturn.ValueData, 0)        AS TotalReturn
                               -- ����� ����� �������� ������ - ��� ���-��
                             , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)     AS TotalPayReturn

                               -- ����� ����� ������ - ��� "��������" ��������� �������: 1)�� %������ + 2)��������������
                             , COALESCE (MIFloat_TotalChangePercent.ValueData, 0) AS TotalChangePercent
                               -- ����� ����� ������ - ��� "������� �����������"
                             , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) AS TotalChangePercentPay

                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                                          AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                          AND MovementLinkObject_To.ObjectId   = vbClientId
                             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                          AND MovementLinkObject_From.ObjectId   = vbUnitId
                             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                         ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                        AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                         ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                         ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                         ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                         ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                         ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                         ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                         ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

                        WHERE Movement.DescId   = zc_Movement_Sale()
                          -- !!!�������� - ����� �������� ������ �����������!!!
                          AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                          -- ���� ���� ����
                          AND 0 <> zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                 - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                 - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                 - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                 - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                                   -- ��� ��������� �������
                                 - COALESCE (MIFloat_TotalReturn.ValueData, 0)
                       )

     , tmpMI_Master AS (SELECT MI_Master.Id                                              AS MovementItemId
                             , MI_Master.PartionId                                       AS PartionId
                             , MI_Master.ObjectId                                        AS GoodsId
                             , MI_Master.Amount                                          AS Amount_master
                             , COALESCE (MIFloat_SummChangePercent_master.ValueData, 0)  AS SummChangePercent_master
                             , COALESCE (MIFloat_TotalPay_master.ValueData, 0)           AS TotalPay_master
                             , COALESCE (MIString_Comment_master.ValueData,'')           AS Comment_master
                             , MI_Master.isErased                                        AS isErased
                             , ROW_NUMBER() OVER (PARTITION BY MI_Master.isErased ORDER BY MI_Master.Id ASC) AS Ord

                             , Movement.Id                                        AS MovementId
                             , Movement.DescId                                    AS DescId
                             , Movement.OperDate                                  AS OperDate
                             , Movement.InvNumber                                 AS InvNumber
                             , Object_PartionMI.ObjectCode                        AS SaleMI_ID
                             , MovementItem.Amount                                AS Amount
                             , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList

                               -- ����� ����� ������ - ��� "��������" ��������� �������
                             , COALESCE (MIFloat_TotalPay.ValueData, 0)           AS TotalPay
                               -- ����� ����� ������ - ��� "������� �����������"
                             , COALESCE (MIFloat_TotalPayOth.ValueData, 0)        AS TotalPayOth

                               -- ����� ���������� �������� - ��� ���-��
                             , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)   AS Amount_Return
                               -- ����� ����� �������� �� �������  - ��� ���-��
                             , COALESCE (MIFloat_TotalReturn.ValueData, 0)        AS TotalReturn
                               -- ����� ����� �������� ������ - ��� ���-��
                             , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)     AS TotalPayReturn

                               -- ����� ����� ������ - ��� "��������" ��������� �������: 1)�� %������ + 2)��������������
                             , COALESCE (MIFloat_TotalChangePercent.ValueData, 0) AS TotalChangePercent
                               -- ����� ����� ������ - ��� "������� �����������"
                             , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) AS TotalChangePercentPay

                        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                             JOIN MovementItem AS MI_Master
                                               ON MI_Master.MovementId = inMovementId
                                              AND MI_Master.DescId     = zc_MI_Master()
                                              AND MI_Master.isErased   = tmpIsErased.isErased

                             LEFT JOIN MovementItemString AS MIString_Comment_master
                                                          ON MIString_Comment_master.MovementItemId = MI_Master.Id
                                                         AND MIString_Comment_master.DescId         = zc_MIString_Comment()

                             LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_master
                                                         ON MIFloat_SummChangePercent_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_SummChangePercent_master.DescId         = zc_MIFloat_SummChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_master
                                                         ON MIFloat_TotalPay_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPay_master.DescId         = zc_MIFloat_TotalPay()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                              ON MILinkObject_PartionMI.MovementItemId = MI_Master.Id
                                                             AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                             LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                             LEFT JOIN MovementItem ON MovementItem.Id = Object_PartionMI.ObjectCode
                             LEFT JOIN Movement     ON Movement.Id     = MovementItem.MovementId

                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                         ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                        AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                         ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                         ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                         ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                         ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                         ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                         ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                         ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
                       )

            , tmpMI AS (SELECT COALESCE (tmpMI_Master.MovementItemId, 0)               AS Id
                             , COALESCE (tmpMI_Master.PartionId, tmpMI_Sale.PartionId) AS PartionId
                             , COALESCE (tmpMI_Master.GoodsId, tmpMI_Sale.GoodsId)     AS GoodsId
                             , COALESCE (tmpMI_Master.Amount_master, 0)                AS Amount
                             , COALESCE (tmpMI_Master.SummChangePercent_master, 0)     AS SummChangePercent
                             , COALESCE (tmpMI_Master.TotalPay_master, 0)              AS TotalPay
                             , COALESCE (tmpMI_Master.Comment_master, '')              AS Comment
                             , COALESCE (tmpMI_Master.isErased, FALSE)                 AS isErased
                             , COALESCE (tmpMI_Master.Ord, 0)                          AS Ord

                             , COALESCE (tmpMI_Master.MovementId, tmpMI_Sale.MovementId)         AS MovementId_Sale
                             , COALESCE (tmpMI_Master.DescId, tmpMI_Sale.DescId)                 AS DescId_Sale
                             , COALESCE (tmpMI_Master.OperDate, tmpMI_Sale.OperDate)             AS OperDate_Sale
                             , COALESCE (tmpMI_Master.InvNumber, tmpMI_Sale.InvNumber)           AS InvNumber_Sale
                             , COALESCE (tmpMI_Master.SaleMI_ID, tmpMI_Sale.SaleMI_ID)           AS SaleMI_Id
                             , COALESCE (tmpMI_Master.Amount, tmpMI_Sale.Amount)                 AS Amount_Sale
                             , COALESCE (tmpMI_Master.OperPriceList, tmpMI_Sale.OperPriceList)   AS OperPriceList_Sale

                             , COALESCE (tmpMI_Master.TotalPay, tmpMI_Sale.TotalPay)             AS TotalPay_Sale
                             , COALESCE (tmpMI_Master.TotalPayOth, tmpMI_Sale.TotalPayOth)       AS TotalPayOth_Sale

                             , COALESCE (tmpMI_Master.Amount_Return, tmpMI_Sale.Amount_Return)   AS Amount_Return
                             , COALESCE (tmpMI_Master.TotalReturn, tmpMI_Sale.TotalReturn)       AS TotalReturn
                             , COALESCE (tmpMI_Master.TotalPayReturn, tmpMI_Sale.TotalPayReturn) AS TotalPay_Return

                               -- ����� ����� ������ - ��� "��������" ��������� �������: 1)�� %������ + 2)��������������
                             , COALESCE (tmpMI_Master.TotalChangePercent, tmpMI_Sale.TotalChangePercent)       AS TotalChangePercent_Sale
                               -- ����� ����� ������ - ��� "������� �����������"
                             , COALESCE (tmpMI_Master.TotalChangePercentPay, tmpMI_Sale.TotalChangePercentPay) AS TotalChangePercentPay_Sale

                  FROM tmpMI_Sale
                       FULL JOIN tmpMI_Master ON tmpMI_Master.SaleMI_Id = tmpMI_Sale.SaleMI_Id  -- ������ �� ������
                                             -- AND tmpMI_Master.GoodsId   = tmpMI_Sale.GoodsId
                  -- WHERE tmpMI_Sale.SummDebt <> 0 OR tmpMI_Master.SaleMI_Id > 0
                 )

    , tmpMI_Child AS (SELECT COALESCE (MovementItem.ParentId, 0) AS ParentId
                           , SUM (CASE WHEN MovementItem.ParentId IS NULL
                                            -- ��������� ����� � ��� ��� �����
                                            THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                       WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                            THEN MovementItem.Amount
                                       ELSE 0
                                  END) AS Amount_GRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END) AS Amount_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END) AS Amount_EUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END)                                                 AS Amount_Bank

                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()

                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                      GROUP BY MovementItem.ParentId
                     )

       -- ���������
       SELECT
             tmpMI.Id                         :: Integer AS Id
           , tmpMI.PartionId                  :: Integer AS PartionId
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , Object_CompositionGroup.ValueData           AS CompositionGroupName
           , Object_Composition.ValueData                AS CompositionName
           , Object_GoodsInfo.ValueData                  AS GoodsInfoName
           , Object_LineFabrica.ValueData                AS LineFabricaName
           , Object_Label.ValueData                      AS LabelName
           , Object_GoodsSize.ValueData                  AS GoodsSizeName

           , tmpMI.Amount                      :: TFloat AS Amount
           , tmpMI.Amount_Sale                 :: TFloat AS Amount_Sale
           , 0                                 :: TFloat AS OperPrice
           , 0                                 :: TFloat AS CountForPrice
           , tmpMI.OperPriceList_Sale          :: TFloat AS OperPriceList

             -- ����� ����� (� ����.)
           , 0                                 :: TFloat AS TotalSumm
           , zfCalc_SummPriceList (tmpMI.Amount_Sale, tmpMI.OperPriceList_Sale) AS TotalSummPriceList

             -- ���� ��� �������� �� ������ ������ � ��� - ������� �������
           , 0 :: TFloat AS CurrencyValue
           , 0 :: TFloat AS ParValue

             -- ����� ����� ������ - ��� "��������" ��������� �������
           , tmpMI.TotalPay_Sale               :: TFloat AS TotalPay_Sale
             -- ����� ����� ������ - ��� "������� �����������"
           , tmpMI.TotalPayOth_Sale            :: TFloat AS TotalPayOth_Sale

             -- ����� ���������� �������� - ��� ���-��
           , tmpMI.Amount_Return               :: TFloat AS Amount_Return
             -- ����� ����� �������� �� �������  - ��� ���-��
           , tmpMI.TotalReturn                 :: TFloat AS TotalReturn
             -- ����� ����� �������� ������ - ��� ���-��
           , tmpMI.TotalPay_Return             :: TFloat AS TotalPay_Return

             -- ����� �����
           , (zfCalc_SummPriceList (tmpMI.Amount_Sale, tmpMI.OperPriceList_Sale)
            - tmpMI.TotalChangePercent_sale
            - tmpMI.TotalChangePercentPay_sale
            - tmpMI.TotalPay_Sale
            - tmpMI.TotalPayOth_Sale
              -- ��� ��������� �������
            - tmpMI.TotalReturn
              -- ���� �� ������� - ��������� ���� �� ����� �� ���. ���������
            - CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN tmpMI.TotalPay ELSE 0 END
            - CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN tmpMI.SummChangePercent ELSE 0 END
             ) :: TFloat AS SummDebt

             -- % ������
           , COALESCE (MIFloat_ChangePercent.ValueData, 0)      :: TFloat AS ChangePercent

             -- ����� ����� ������ - ��� "��������" ��������� �������: 2)��������������
           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)  :: TFloat AS SummChangePercent_sale
             -- ����� ����� ������ - ��� "��������" ��������� �������: 1)�� %������
           , (tmpMI.TotalChangePercent_sale - COALESCE (MIFloat_SummChangePercent.ValueData, 0)) :: TFloat AS TotalChangePercent_sale
             -- ����� ����� ������ - ��� "������� �����������"
           , tmpMI.TotalChangePercentPay_sale                   :: TFloat AS TotalChangePercentPay

             -- ����� � ������
           , (zfCalc_SummPriceList (tmpMI.Amount_Sale, tmpMI.OperPriceList_Sale)
            - tmpMI.TotalChangePercent_sale
            - tmpMI.TotalChangePercentPay_sale
            - tmpMI.TotalPay_Sale
            - tmpMI.TotalPayOth_Sale
              -- ��� ��������� �������
            - tmpMI.TotalReturn
              -- ���� �� ������� - ��������� ���� �� ����� �� ���. ���������
            + CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN tmpMI.TotalPay ELSE 0 END
            + CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN tmpMI.SummChangePercent ELSE 0 END
             ) :: TFloat AS TotalSummToPay

           , tmpMI_Child.Amount_GRN            :: TFloat AS TotalPay_Grn
           , tmpMI_Child.Amount_USD            :: TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR            :: TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank           :: TFloat AS TotalPay_Card
           , tmpMI.TotalPay                    :: TFloat AS TotalPay
           , tmpMI.SummChangePercent           :: TFloat AS SummChangePercent


           , tmpMI_Child_Exc.Amount_USD        :: TFloat AS Amount_USD_Exc    -- ����� USD - ����� ������
           , tmpMI_Child_Exc.Amount_EUR        :: TFloat AS Amount_EUR_Exc    -- ����� EUR - ����� ������
           , tmpMI_Child_Exc.Amount_GRN        :: TFloat AS Amount_GRN_Exc    -- ����� GRN - ����� ������

           , tmpMI.SaleMI_Id                   :: Integer   AS SaleMI_Id
           , tmpMI.MovementId_Sale             :: Integer   AS MovementId_Sale
           , tmpMI.InvNumber_Sale              :: TVarChar  AS InvNumber_Sale_Full
           , tmpMI.OperDate_Sale               :: TDateTime AS OperDate_Sale
           , MovementDesc.ItemName                          AS DescName

           , tmpMI.Comment                     :: TVarChar  AS Comment
           , tmpMI.isErased                    :: Boolean   AS isErased

       FROM tmpMI
            -- ����� ������
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            -- ����� ������
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMI.DescId_Sale
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = tmpMI.SaleMI_Id
                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                        ON MIFloat_SummChangePercent.MovementItemId = tmpMI.SaleMI_Id
                                       AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
       ;

     ELSE
     -- ��������� �����
     RETURN QUERY
     WITH
       tmpMI_Master AS (SELECT MI_Master.Id                                              AS Id
                             , MI_Master.PartionId                                       AS PartionId
                             , MI_Master.ObjectId                                        AS GoodsId
                             , MI_Master.Amount                                          AS Amount
                             , COALESCE (MIFloat_SummChangePercent_master.ValueData, 0)  AS SummChangePercent
                             , COALESCE (MIFloat_TotalPay_master.ValueData, 0)           AS TotalPay
                             , COALESCE (MIString_Comment_master.ValueData,'')           AS Comment
                             , MI_Master.isErased                                        AS isErased
                             , ROW_NUMBER() OVER (PARTITION BY MI_Master.isErased ORDER BY MI_Master.Id ASC) AS Ord

                             , Object_PartionMI.ObjectCode                               AS SaleMI_ID

                        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                             JOIN MovementItem AS MI_Master
                                               ON MI_Master.MovementId = inMovementId
                                              AND MI_Master.DescId     = zc_MI_Master()
                                              AND MI_Master.isErased   = tmpIsErased.isErased

                             LEFT JOIN MovementItemString AS MIString_Comment_master
                                                          ON MIString_Comment_master.MovementItemId = MI_Master.Id
                                                         AND MIString_Comment_master.DescId         = zc_MIString_Comment()

                             LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_master
                                                         ON MIFloat_SummChangePercent_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_SummChangePercent_master.DescId         = zc_MIFloat_SummChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_master
                                                         ON MIFloat_TotalPay_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPay_master.DescId         = zc_MIFloat_TotalPay()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                              ON MILinkObject_PartionMI.MovementItemId = MI_Master.Id
                                                             AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                             LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                       )

    , tmpMI_Child AS (SELECT COALESCE (MovementItem.ParentId, 0) AS ParentId
                           , SUM (CASE WHEN MovementItem.ParentId IS NULL
                                            -- ��������� ����� � ��� ��� �����
                                            THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                       WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                            THEN MovementItem.Amount
                                       ELSE 0
                                  END) AS Amount_GRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END) AS Amount_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END) AS Amount_EUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END)                                                 AS Amount_Bank

                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()

                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                      GROUP BY MovementItem.ParentId
                     )

       -- ���������
       SELECT
             tmpMI.Id                                          :: Integer AS Id
           , tmpMI.PartionId                                   :: Integer AS PartionId
           , Object_Goods.Id                                              AS GoodsId
           , Object_Goods.ObjectCode                                      AS GoodsCode
           , Object_Goods.ValueData                                       AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData                  AS GoodsGroupNameFull
           , Object_Measure.ValueData                                     AS MeasureName
           , Object_CompositionGroup.ValueData                            AS CompositionGroupName
           , Object_Composition.ValueData                                 AS CompositionName
           , Object_GoodsInfo.ValueData                                   AS GoodsInfoName
           , Object_LineFabrica.ValueData                                 AS LineFabricaName
           , Object_Label.ValueData                                       AS LabelName
           , Object_GoodsSize.ValueData                                   AS GoodsSizeName

           , tmpMI.Amount                                       :: TFloat AS Amount
           , MI_Sale.Amount                                     :: TFloat AS Amount_Sale
           , 0                                                  :: TFloat AS OperPrice
           , 0                                                  :: TFloat AS CountForPrice
           , COALESCE (MIFloat_OperPriceList.ValueData, 0)      :: TFloat AS OperPriceList

             -- ����� ����� (� ����.)
           , 0                                                  :: TFloat AS TotalSumm
           , zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData) AS TotalSummPriceList

             -- ���� ��� �������� �� ������ ������ � ��� - ������� �������
           , 0                                                  :: TFloat AS CurrencyValue
           , 0                                                  :: TFloat AS ParValue

             -- ����� ����� ������ - ��� "��������" ��������� �������
           , COALESCE (MIFloat_TotalPay.ValueData, 0)           ::TFloat AS TotalPay_Sale
             -- ����� ����� ������ - ��� "������� �����������"
           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)        ::TFloat AS TotalPayOth_Sale

             -- ����� ����� �������� ������ - ��� ���-��
           , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)   ::TFloat AS Amount_Return
             -- ����� ����� �������� ������ - ��� ���-��
           , COALESCE (MIFloat_TotalReturn.ValueData, 0)        ::TFloat AS TotalReturn
             -- ����� ����� �������� ������ - ��� ���-��
           , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)     ::TFloat AS TotalPay_Return

             -- ����� �����
           , (zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)
            - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
            - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
              -- ��� ��������� �������
            - COALESCE (MIFloat_TotalReturn.ValueData, 0)
              -- ���� �� ������� - ��������� ���� �� ����� �� ���. ���������
            - CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN tmpMI.TotalPay ELSE 0 END
            - CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN tmpMI.SummChangePercent ELSE 0 END
             ) :: TFloat AS SummDebt

             -- % ������
           , COALESCE (MIFloat_ChangePercent.ValueData, 0)      :: TFloat AS ChangePercent
             -- ����� ����� ������ - ��� "��������" ��������� �������: 2)��������������
           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)  :: TFloat AS SummChangePercent_sale
             -- ����� ����� ������ - ��� "��������" ��������� �������: 1)�� %������
           , (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) - COALESCE (MIFloat_SummChangePercent.ValueData, 0)) :: TFloat AS TotalChangePercent_sale
             -- ����� ����� ������ - ��� "������� �����������"
           , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) :: TFloat AS TotalChangePercentPay

             -- ����� � ������
           , (zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)
            - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
            - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
              -- ��� ��������� �������
            - COALESCE (MIFloat_TotalReturn.ValueData, 0)
              -- ���� ������� - ������ ������� ����� �� ���. ���������
            + CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN tmpMI.TotalPay ELSE 0 END
            + CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN tmpMI.SummChangePercent ELSE 0 END
             ) :: TFloat AS TotalSummToPay

           , tmpMI_Child.Amount_GRN                             :: TFloat AS TotalPay_Grn
           , tmpMI_Child.Amount_USD                             :: TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR                             :: TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank                            :: TFloat AS TotalPay_Card
           , tmpMI.TotalPay                                     :: TFloat AS TotalPay
           , tmpMI.SummChangePercent                            :: TFloat AS SummChangePercent


           , tmpMI_Child_Exc.Amount_USD                         :: TFloat AS Amount_USD_Exc    -- ����� USD - ����� ������
           , tmpMI_Child_Exc.Amount_EUR                         :: TFloat AS Amount_EUR_Exc    -- ����� EUR - ����� ������
           , tmpMI_Child_Exc.Amount_GRN                         :: TFloat AS Amount_GRN_Exc    -- ����� GRN - ����� ������

           , tmpMI.SaleMI_ID                                   :: Integer AS SaleMI_Id
           , Movement_Sale.Id                                             AS MovementId_Sale
           , Movement_Sale.InvNumber                                      AS InvNumber_Sale_Full
           , Movement_Sale.OperDate                                       AS OperDate_Sale
           , MovementDesc.ItemName                                        AS DescName
           , tmpMI.Comment                                    :: TVarChar AS Comment
           , tmpMI.isErased                                               AS isErased

       FROM tmpMI_Master AS tmpMI
            -- ����� ������
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            -- ����� ������
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

           LEFT JOIN MovementItem AS MI_Sale    ON MI_Sale.Id          = tmpMI.SaleMI_Id
           LEFT JOIN Movement AS Movement_Sale  ON Movement_Sale.Id    = MI_Sale.MovementId
           LEFT JOIN MovementDesc               ON MovementDesc.Id     = Movement_Sale.DescId
           ----
           LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                       ON MIFloat_OperPriceList.MovementItemId = MI_Sale.Id
                                      AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                       ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                      AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
           LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                       ON MIFloat_SummChangePercent.MovementItemId = MI_Sale.Id
                                      AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                       ON MIFloat_TotalChangePercent.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                       ON MIFloat_TotalChangePercentPay.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

           LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                       ON MIFloat_TotalPay.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                       ON MIFloat_TotalPayOth.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

           LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                       ON MIFloat_TotalCountReturn.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
           LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                       ON MIFloat_TotalReturn.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                       ON MIFloat_TotalPayReturn.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
       ;

       END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 06.07.17         *
 18.05.17         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_GoodsAccount (inMovementId:= 241258, inShowAll:= TRUE,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_MovementItem_GoodsAccount (inMovementId:= 241258, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
