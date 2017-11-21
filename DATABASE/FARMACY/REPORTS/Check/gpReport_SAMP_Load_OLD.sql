-- Function:  gpReport_SAMP_Load()

DROP FUNCTION IF EXISTS gpReport_SAMP_Load (Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_SAMP_Load(
    IN inMovementId       Integer  ,  --
    IN inUnitId           Integer  ,  -- �������������
    IN inStartSale        TDateTime,  -- ���� ������ ������
    IN inEndSale          TDateTime,  -- ���� ��������� ������
--    IN inOperDateStart    TDateTime,  -- ���� ������ �������� ��������� �� ��������� �������
--    IN inOperDateEnd      TDateTime,  -- ���� ��������� �������� ��������� �� ��������� �������
    IN inAmount           TFloat,     -- ��� ���-�� ������ �� ������������� ������
    IN inChangePercent    TFloat,     -- % ���������� ������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbDate1   TDateTime;
   DECLARE vbDate2   TDateTime;
   DECLARE vbDate3   TDateTime;
   DECLARE vbDate4   TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inUnitId, 0) = 0
    THEN
        RAISE EXCEPTION '������.�� ������� �������������.';
    END IF;
     
    vbDate1 := inEndSale - INTERVAL '7 DAY';
    vbDate2 := vbDate1 - INTERVAL '7 DAY';
    vbDate3 := vbDate2 - INTERVAL '7 DAY';
    vbDate4 := vbDate3 - INTERVAL '7 DAY';    
    
    -- ���������

   CREATE TEMP TABLE _tmpMI (Id Integer, GoodsId Integer) ON COMMIT DROP;
   -- ��� ����������� ������  
   INSERT INTO _tmpMI (Id, GoodsId)
               SELECT MovementItem.Id 
                    , MovementItem.ObjectId AS GoodsId
               FROM MovementItem
               WHERE MovementItem.MovementId = inMovementId
                 ANd MovementItem.DescId = zc_MI_Master()
               ;
               
    CREATE TEMP TABLE _tmpData (GoodsId Integer, Amount TFloat, AmountAnalys TFloat) ON COMMIT DROP;
    WITH
    -- ������� �� ������ �� �������������, ������� ������ � ���������� � 7 ����
    tmpData_Container AS (SELECT MIContainer.ObjectId_analyzer               AS GoodsId
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                               , SUM (CASE WHEN MIContainer.OperDate > vbDate1 THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS AmountAnalys1
                               , SUM (CASE WHEN MIContainer.OperDate > vbDate2 AND MIContainer.OperDate <= vbDate1 THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS AmountAnalys2
                               , SUM (CASE WHEN MIContainer.OperDate > vbDate3 AND MIContainer.OperDate <= vbDate2 THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS AmountAnalys3
                               , SUM (CASE WHEN MIContainer.OperDate > vbDate4 AND MIContainer.OperDate <= vbDate3 THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS AmountAnalys4
                          FROM MovementItemContainer AS MIContainer
                          WHERE MIContainer.DescId = zc_MIContainer_Count()
                            AND MIContainer.MovementDescId = zc_Movement_Check()
                            AND MIContainer.WhereObjectId_analyzer = inUnitId
                            AND MIContainer.OperDate >= inStartSale AND MIContainer.OperDate < inEndSale + INTERVAL '1 DAY'
                          GROUP BY MIContainer.ObjectId_analyzer
                          --HAVING (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                          )
              
   -- ����������� �������, � ������� ������� ����� ��� ������� �� 20%, �� ��������� 7 ���� �������������� ������� �������� � �����.                      
   INSERT INTO _tmpData (GoodsId, Amount, AmountAnalys)
                 SELECT tmp.GoodsId
                      , tmp.Amount
                      , tmp.AmountAnalys1
                 FROM (SELECT tmpData_Container.*
                            , (tmpData_Container.AmountAnalys1 + tmpData_Container.AmountAnalys1 * inChangePercent/100)    AS AmountAnalys1_WithPerSent
                            , (tmpData_Container.AmountAnalys1 - tmpData_Container.AmountAnalys1 * inChangePercent/100)    AS AmountAnalys1_WithOutPerSent
                            
                       FROM tmpData_Container
                       WHERE tmpData_Container.AmountAnalys1 >= inAmount
                         AND tmpData_Container.AmountAnalys2 >= inAmount
                         AND tmpData_Container.AmountAnalys3 >= inAmount
                         AND tmpData_Container.AmountAnalys4 >= inAmount
                       ) AS tmp
                 WHERE tmp.AmountAnalys1_WithPerSent    <= tmp.AmountAnalys2
                    OR tmp.AmountAnalys1_WithPerSent    <= tmp.AmountAnalys3
                    OR tmp.AmountAnalys1_WithPerSent    <= tmp.AmountAnalys4 -- ������� �����
                    OR tmp.AmountAnalys1_WithOutPerSent >= tmp.AmountAnalys2
                    OR tmp.AmountAnalys1_WithOutPerSent >= tmp.AmountAnalys3
                    OR tmp.AmountAnalys1_WithOutPerSent >= tmp.AmountAnalys4
                 ;

   --��������� ��� ����� , �������� ������� ����� ����� �� ������, ����� ������ �������
   
   -- ������ ������� �������� �� ���� (���� ����� �� �������� ���� ����� ������������)
   UPDATE MovementItem 
      SET isErased = FALSE
   WHERE MovementItem.MovementId = inMovementId;
   
   WITH 
   tmpMI_Del AS (SELECT COALESCE (tmpMI.Id, 0) AS Id
              FROM _tmpData
                  FULL JOIN tmpMI ON tmpMI.GoodsId = _tmpData.GoodsId
              WHERE _tmpData.GoodsId IS NULL
              )
   UPDATE MovementItem 
         SET isErased = TRUE 
   WHERE MovementItem.Id IN (SELECT tmpMI_Del.Id FROM tmpMI_Del);
   
   PERFORM lpInsertUpdate_MI_MarginCategory_Master (ioId           := COALESCE (_tmpMI.Id, 0)  ::integer
                                                  , inMovementId   := inMovementId
                                                  , inGoodsId      := _tmpData.GoodsId
                                                  , inAmount       := _tmpData.Amount
                                                  , inAmountAnalys := _tmpData.AmountAnalys
                                                  , inUserId       := vbUserId
                                                  )
   FROM _tmpData   
       LEFT JOIN _tmpMI ON _tmpMI.GoodsId = _tmpData.GoodsId
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 20.11.17         *
*/

-- ����
-- select * from gpReport_SAMP_Load(inMovementId := 3959786 , inUnitId := 472116 , inStartSale := ('01.10.2017')::TDateTime , inEndSale := ('31.10.2017')::TDateTime , inAmount := 2 , inChangePercent := 10 ,  inSession := '3');