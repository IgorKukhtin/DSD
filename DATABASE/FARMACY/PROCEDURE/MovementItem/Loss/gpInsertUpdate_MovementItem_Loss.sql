-- Function: gpInsertUpdate_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Loss(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
 INOUT ioPriceIn             TFloat    , -- ���� �������
   OUT outSumm               TFloat    , -- �����
   OUT outSummIn             TFloat    , -- ����� ������� 
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdatePriceIn Boolean;
   DECLARE vbPriceIn TFloat;
   DECLARE vbStatusID Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Loss());
    vbUserId:= lpGetUserBySession (inSession);
    --��������� �� ������������ ���-��

    IF (inAmount < 0)
    THEN
      RAISE EXCEPTION '������. ���������� <%> �� ����� ���� ������ ����.', inAmount;
    END IF;    

    -- ��������� ���������
    SELECT Movement.StatusID
         , MovementLinkObject_Unit.ObjectId
         , DATE_TRUNC('day', Movement.OperDate) + INTERVAL '1 DAY'
    INTO vbStatusID, vbUnitId, vbOperDate
    FROM Movement
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;
    
    IF vbStatusID = zc_Enum_Status_Complete()
    THEN

      SELECT CASE WHEN SUM(-MovementItemContainer.Amount) <> 0 
                  THEN SUM(-MovementItemContainer.Amount * MIFloat_Income_Price.ValueData) / SUM(-MovementItemContainer.Amount)
                  END::TFloat AS Price
      INTO vbPriceIn
      FROM MovementItemContainer 
          LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                              ON CLI_MI.containerid = MovementItemContainer.ContainerId
                                             AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
          LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

          -- ������� �������
          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
          -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                      ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
          -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

          LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                            ON MIFloat_Income_Price.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id) 
                                           AND MIFloat_Income_Price.DescId = zc_MIFloat_PriceWithVAT()
      WHERE MovementItemContainer.MovementId = inMovementId
        AND MovementItemContainer.MovementItemId = ioId
        AND MovementItemContainer.DescId = zc_MIContainer_Count()
      GROUP BY MovementItemContainer.MovementItemId;
      
    ELSE
    
      SELECT SUM(Container.Amount * MIFloat_Income_Price.ValueData) / SUM(Container.Amount)
      INTO vbPriceIn
      FROM (SELECT Container.Id 
                 , Container.ObjectId 
                 , (Container.Amount - SUM (COALESCE(MovementItemContainer.amount, 0 )) ) ::TFloat AS Amount  --���. ������� - �������� ����� ���� ���������
            FROM Container AS Container
            
                 LEFT JOIN MovementItemContainer AS MovementItemContainer 
                                                 ON MovementItemContainer.ContainerId = Container.Id
                                                AND MovementItemContainer.Operdate >= vbOperDate
                                                
            WHERE Container.DescID = zc_Container_Count()
              AND Container.ObjectId = inGoodsId
              AND Container.WhereObjectId = vbUnitId
            GROUP BY Container.Id 
                   , Container.Amount
            HAVING Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0) <> 0) AS Container

          LEFT OUTER JOIN containerlinkobject AS CLI_MI 
                                              ON CLI_MI.containerid = Container.Id
                                             AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
          LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

          -- ������� �������
          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
          -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                      ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
          -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

          LEFT OUTER JOIN MovementitemFloat AS MIFloat_Income_Price
                                            ON MIFloat_Income_Price.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id) 
                                           AND MIFloat_Income_Price.DescId = zc_MIFloat_PriceWithVAT()
      GROUP BY Container.ObjectId
      HAVING SUM(Container.Amount) <> 0;                        
                    
    END IF;
    
    if vbUserId IN (3, 59591, 183242, 4183126)
    THEN
      if COALESCE(ioPriceIn, 0) = 0 AND COALESCE((SELECT MIFloat_PriceIn.ValueData
                                                  FROM MovementItemFloat AS MIFloat_PriceIn
                                                  WHERE MIFloat_PriceIn.MovementItemId = ioId
                                                    AND MIFloat_PriceIn.DescId = zc_MIFloat_PriceIn()), 0) > 0
      THEN 
        vbIsUpdatePriceIn := True; 
      ELSEIF COALESCE(ioPriceIn, 0) > 0 AND
             COALESCE(NULLIF((SELECT MIFloat_PriceIn.ValueData
                             FROM MovementItemFloat AS MIFloat_PriceIn
                             WHERE MIFloat_PriceIn.MovementItemId = ioId
                               AND MIFloat_PriceIn.DescId = zc_MIFloat_PriceIn()), 0), vbPriceIn, ioPriceIn) <> ioPriceIn
      THEN
        vbIsUpdatePriceIn := True;       
      ELSE 
        vbIsUpdatePriceIn := False; 
      END IF;
    ELSE 
      vbIsUpdatePriceIn := False;       
    END IF;
    
     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Loss (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inUserId             := vbUserId
                                             );
                                             
    IF vbIsUpdatePriceIn = TRUE
    THEN
    
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn(), ioId, ioPriceIn);  
    
      IF COALESCE (ioPriceIn, 0) = 0
      THEN
        ioPriceIn := vbPriceIn;      
      END IF;

    raise notice 'Value 01: % % %', vbIsUpdatePriceIn, ioPriceIn, vbPriceIn;
      
    ELSE
    
      ioPriceIn := COALESCE(NULLIF((SELECT MIFloat_PriceIn.ValueData
                                    FROM MovementItemFloat AS MIFloat_PriceIn
                                    WHERE MIFloat_PriceIn.MovementItemId = ioId
                                      AND MIFloat_PriceIn.DescId = zc_MIFloat_PriceIn()), 0), vbPriceIn);    
          
    END IF;
    
    outSumm := ROUND(inAmount * inPrice,2);
    outSummIn := ROUND(inAmount * ioPriceIn,2);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 20.07.15                                                                    *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_Loss(ioId := 637327724 , inMovementId := 34124891 , inGoodsId := 6792296 , inAmount := 1 , inPrice := 39.1 , ioPriceIn := 0,  inSession := '3');