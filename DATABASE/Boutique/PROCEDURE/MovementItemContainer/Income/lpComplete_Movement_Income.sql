DROP FUNCTION IF EXISTS lpComplete_Movement_Income (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Currency_byItem TFloat;
  DECLARE vbOperSumm_Currency TFloat;

  DECLARE vbOperDate       TDateTime;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbUnitId         Integer;

  DECLARE vbCurrencyDocumentId Integer;
  DECLARE vbCurrencyValue      TFloat;
  DECLARE vbParValue           TFloat;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummPartner;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ��������� �� ���������
     SELECT _tmp.OperDate, _tmp.PartnerId_From, _tmp.UnitId
          , _tmp.CurrencyDocumentId, _tmp.CurrencyValue, _tmp.ParValue
            INTO vbOperDate
               , vbPartnerId_From
               , vbUnitId
               , vbCurrencyDocumentId
               , vbCurrencyValue
               , vbParValue
     FROM (SELECT Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner()    THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN Object_To.Id ELSE 0 END, 0) AS UnitId

                , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
                , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
                , COALESCE (MovementFloat_ParValue.ValueData, 0)                                    AS ParValue

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()

                LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                        ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                       AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                        ON MovementFloat_ParValue.MovementId = Movement.Id
                                       AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Income()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods
                         , GoodsId, PartionId
                         , OperCount, OperSumm_Partner, OperSumm_Partner_Currency
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId
                          )
        -- ���������
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Summ          -- ���������� �����
            , 0 AS ContainerId_Goods         -- ���������� �����
            , _tmp.GoodsId
            , _tmp.PartionId

            , _tmp.OperCount

              -- �������� ����� �� �����������
            , _tmp.tmpOperSumm_Partner AS OperSumm_Partner
              -- �������� ����� � ������ �� �����������
            , _tmp.tmpOperSumm_Partner AS OperSumm_Partner

             
            , 0 AS AccountId              -- ����(�����������), ���������� �����

              -- �� ��� Income = �� ���� �����������
            , _tmp.InfoMoneyGroupId
            , _tmp.InfoMoneyDestinationId
            , _tmp.InfoMoneyId

              -- �������� ������ !!!���� �� ������������ ������!!!
            , 0 AS BusinessId 

        FROM (SELECT
                     MovementItem.Id        AS MovementItemId
                   , MovementItem.ObjectId  AS GoodsId
                   , MovementItem.PartionId AS PartionId

                   , MovementItem.Amount                           AS OperCount
                   , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                               -- ��� ����������� � ������ zc_Enum_Currency_Basis
                               THEN CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN vbParValue > 0 THEN vbCurrencyValue / vbParValue ELSE vbCurrencyValue END AS NUMERIC (16, 2))
                          ELSE tmpMI.Price
                     END AS Price
                   , COALESCE (MIFloat_Price.ValueData, 0)         AS Price

                     -- ������������� ����� �� ����������� - � ����������� �� 2-� ������
                   , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN CAST (MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                                                   ELSE CAST (MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                     END AS tmpOperSumm_Partner

                    -- �������������� ������
                  , View_InfoMoney.InfoMoneyGroupId
                    -- �������������� ����������
                  , View_InfoMoney.InfoMoneyDestinationId
                    -- ������ ����������
                  , View_InfoMoney.InfoMoneyId

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MovementItem.ObjectId

              WHERE Movement.Id     = inMovementId
                AND Movement.DescId = zc_Movement_Income()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
            ;

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Income()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 08.06.17                                        *
 25.04.17         *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())

