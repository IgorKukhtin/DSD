-- Function: gpInsertUpdate_ObjectHistory_PriceListItem_Separate()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItem_Separate (TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItem_Separate (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItem_Separate(
    IN inOperDate   TDateTime,
    IN inSession    TVarChar    -- ������ ������������
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
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_ProductionSeparateH());

   -- ���������� ���� ��� ������� ��� - � 1 ����� ���. ������ �� ��������� ����,
   vbStartDate := DATE_TRUNC ('MONTH' , inOperDate);
   vbEndDate   := CASE -- ���� "�������" ����� - ����� ��������� �����
                       WHEN DATE_TRUNC ('MONTH' , inOperDate) < DATE_TRUNC ('MONTH' , CURRENT_DATE)
                            THEN DATE_TRUNC ('MONTH' , inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                       -- ���� "����" ������ ����� - ����� ����� ����� �� 1 ����
                       WHEN DATE_TRUNC ('MONTH' , inOperDate) = CURRENT_DATE
                            THEN DATE_TRUNC ('MONTH' , inOperDate)
                       -- ���� "����" ������ ����� - ����� ����� ����� �� 1 ����
                       WHEN DATE_TRUNC ('MONTH' , inOperDate) = CURRENT_DATE - INTERVAL '1 DAY'
                            THEN DATE_TRUNC ('MONTH' , inOperDate)
                       -- ����� �� 2 ��� ������
                       ELSE CURRENT_DATE - INTERVAL '2 DAY'
                  END;
   

   -- �������� ������ �� ������ ���
   vbPriceListId := zc_PriceList_ProductionSeparateHist();

   
   IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbPriceListId AND Object.DescId = zc_Object_PriceList() AND Object.isErased = FALSE)
   THEN
        --RAISE EXCEPTION '������.����� <������ ��� �� ���� - �������> �� ������';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.����� <%> �� ������' :: TVarChar
                                              , inProcedureName := 'gpInsertUpdate_ObjectHistory_PriceListItem_Separate'   :: TVarChar
                                              , inUserId        := vbUserId);
   END IF;
   

   CREATE TEMP TABLE _tmpData (GoodsId Integer, OperDate TDateTime, Price TFloat) ON COMMIT DROP;
   INSERT INTO _tmpData (GoodsId, OperDate, Price)
      
      WITH tmpMovement AS (SELECT Movement.Id        AS MovementId
                                , Movement.OperDate  AS OperDate
                           FROM Movement 
                                LEFT JOIN MovementBoolean AS MovementBoolean_Calculated
                                                          ON MovementBoolean_Calculated.MovementId = Movement.Id
                                                         AND MovementBoolean_Calculated.DescId     = zc_MovementBoolean_Calculated()
                                                         AND MovementBoolean_Calculated.ValueData  = TRUE
                           WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate 
                             AND Movement.DescId   = zc_Movement_ProductionSeparate()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND MovementBoolean_Calculated.MovementId IS NULL
                          )
          -- ���������� ������ �������� �������
         , tmpMI_Child AS (SELECT tmpMovement.MovementId
                                , tmpMovement.OperDate   AS OperDate
                                , MovementItem.Id        AS MI_Id
                                , MovementItem.ObjectId  AS GoodsId
                              --, MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                           FROM tmpMovement
                                LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                      AND MovementItem.DescId     = zc_MI_Child()
                                                      AND MovementItem.isErased   = FALSE
                           )

         , tmpMIContainer AS (SELECT tmpMI_Child.OperDate                            AS OperDate
                                   , MIContainer.ObjectId_Analyzer                   AS GoodsId
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) AS Amount
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) AS Summ
                              FROM tmpMI_Child
                                   JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementId        = tmpMI_Child.MovementId
                                                             AND MIContainer.MovementItemId    = tmpMI_Child.MI_Id
                                                             AND MIContainer.ObjectId_Analyzer = tmpMI_Child.GoodsId
                              GROUP BY tmpMI_Child.OperDate
                                     , MIContainer.ObjectId_Analyzer
                              HAVING SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) <> 0
                                 AND SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) <> 0
                             )

           SELECT tmp.GoodsId
                , tmp.OperDate
                , CAST (tmp.Summ / tmp.Amount AS NUMERIC (16, 2)) :: TFloat  AS Price   -- ������� ���� �� ����
           FROM tmpMIContainer AS tmp;
           
         -- ���������� �������� 
         PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId          := 0
                                                           , inPriceListId := vbPriceListId
                                                           , inGoodsId     := tmp.GoodsId
                                                           , inOperDate    := tmp.OperDate
                                                           , inValue       := tmp.Price
                                                           , inUserId      := vbUserId
                                                            )
         FROM (SELECT * FROM _tmpData ORDER BY _tmpData.GoodsId, _tmpData.OperDate) AS tmp;
    

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.20         *
 03.10.18         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_ObjectHistory_PriceListItem_Separate (CURRENT_DATE, zfCalc_UserAdmin())
