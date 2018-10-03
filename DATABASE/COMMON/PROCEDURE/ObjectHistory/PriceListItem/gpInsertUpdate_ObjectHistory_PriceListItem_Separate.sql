-- Function: gpInsertUpdate_ObjectHistory_PriceListItem_Separate()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItem_Separate (TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItem_Separate(
    IN inSession     TVarChar    -- ������ ������������
)
  RETURNS VOID AS
$BODY$
DECLARE
   DECLARE vbPriceListId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- ���������� ���� ��� ������� ��� - � 1 ����� ���. ������ �� ��������� ����,
   vbStartDate := DATE_TRUNC ('Month' , CURRENT_DATE);
   vbEndDate   := CASE WHEN DATE_TRUNC ('Month' , CURRENT_DATE) = CURRENT_DATE THEN CURRENT_DATE ELSE CURRENT_DATE - INTERVAL '1 DAY' END;
   
   -- �������� ������ �� ������ ���
   vbPriceListId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PriceList() AND Object.ValueData Like '%������ ��� �� ���� - �������%');
   
   IF COALESCE (vbPriceListId, 0) = 0 
   THEN
        RAISE EXCEPTION '������. ����� <������ ��� �� ���� - �������> �� ������';
   END IF;
   
   CREATE TEMP TABLE _tmpData (GoodsId Integer, OperDate TDateTime, Price TFloat) ON COMMIT DROP;
      INSERT INTO _tmpData (GoodsId, OperDate, Price)
      
      WITH tmpMovement AS (SELECT Movement.Id        AS MovementId
                                , Movement.OperDate  AS OperDate
                           FROM Movement 
                           WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate 
                             AND Movement.DescId  = zc_Movement_ProductionSeparate()
                             AND Movement.StatusId  = zc_Enum_Status_Complete()
                          )
          -- ���������� ������ �������� �������
         , tmpMI_Child AS (SELECT tmpMovement.MovementId
                                , tmpMovement.OperDate   AS OperDate
                                , MovementItem.Id        AS MI_Id
                                , MovementItem.ObjectId  AS GoodsId
                           FROM tmpMovement
                                LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                      AND MovementItem.DescId = zc_MI_Child()
                                                      AND MovementItem.isErased = FALSE
                           --WHERE MovementItem.ObjectId = 2066
                           )

         , tmpMIContainer AS (SELECT tmpMI_Child.MovementId                          AS MovementId
                                   , tmpMI_Child.OperDate                            AS OperDate
                                   , MIContainer.ObjectId_Analyzer                   AS GoodsId
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) AS Amount
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) AS Summ
                              FROM tmpMI_Child
                                   JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementId = tmpMI_Child.MovementId
                                                             AND MIContainer.MovementItemId = tmpMI_Child.MI_Id
                                                             AND MIContainer.ObjectId_Analyzer = tmpMI_Child.GoodsId
                              GROUP BY tmpMI_Child.MovementId
                                     , tmpMI_Child.OperDate
                                     , MIContainer.ObjectId_Analyzer
                              HAVING SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) <> 0
                                 AND SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) <> 0
                              )

           SELECT tmp.GoodsId
                , tmp.OperDate
                , CAST (AVG (tmp.Summ / tmp.Amount) AS NUMERIC (16,2) ) ::TFloat  AS Price   -- ������� ���� �� ����
           FROM tmpMIContainer AS tmp
           GROUP BY tmp.OperDate, tmp.GoodsId;
           
         -- ���������� �������� 
         PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId := 0 --ioId
                                                           , inPriceListId := vbPriceListId
                                                           , inGoodsId     := tmp.GoodsId
                                                           , inOperDate    := tmp.OperDate
                                                           , inValue       := tmp.Price    ::TFloat 
                                                           , inUserId      := vbUserId
                                                           )
         FROM _tmpData AS tmp;
    

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 03.10.18         *
*/
select gpInsertUpdate_ObjectHistory_PriceListItem_Separate ('5')