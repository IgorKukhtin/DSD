-- Function: gpGet_Movement_Check_PairSunAmount()

DROP FUNCTION IF EXISTS gpGet_Movement_Check_PairSunAmount (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_PairSunAmount(
    IN inGoodsId            Integer   , --      
    IN inNDSKindId          Integer   , --      
    IN inPartionDateKindId  Integer   , --      
    IN inDivisionPartiesId  Integer   , --      
    IN inAmount             TFloat    , -- 
   OUT outAmount            TFloat    , -- 
   OUT outJuridicalId       Integer   , -- вернули, если есть
   OUT outJuridicalName     TVarChar  , -- вернули, если есть
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbIndex Integer;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    vbUnitKey := COALESCE (lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    vbUnitId  := CASE WHEN vbUnitKey = '' THEN '0' ELSE vbUnitKey END :: Integer;

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();
    
    
    outJuridicalId := 0;
    outJuridicalName := '';
    outAmount := 0;
    vbJuridicalId := 59611;

    WITH tmpContainerAll AS (SELECT Container.ObjectId                                               AS GoodsId, 
                                    Container.Id, 
                                    Container.Amount,
                                    COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)        AS M_Income
                              FROM Container

                                   LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                 ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                                AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                   LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                   -- элемент прихода
                                   LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                   -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                               ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                   -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                   LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                   
                              WHERE Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.ObjectId = inGoodsId
                                AND Container.Amount > 0
                              )
       , tmpContainer AS (SELECT Container.GoodsId, 
                                 Container.Id, 
                                 Container.Amount,
                                 CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                        OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                      THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId,
                                 ContainerLinkObject_DivisionParties.ObjectId                                   AS DivisionPartiesId,
                                 MovementLinkObject_From.ObjectId                                               AS JuridicalId
                           FROM tmpContainerAll AS Container
                                                                 
                                LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.GoodsId
                                LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                                LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                ON MovementBoolean_UseNDSKind.MovementId = Container.M_Income
                                                               AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                             ON MovementLinkObject_NDSKind.MovementId = Container.M_Income
                                                            AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                                                                                   
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Container.M_Income
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                              ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                             AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                                                      
                              )
       , tmpContainerPDAll AS  (SELECT Container.ParentId
                                     , Container.Amount
                                     , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                 COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                  THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                            WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                            ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
                                FROM tmpContainer

                                     INNER JOIN Container ON Container.ParentId = tmpContainer.Id
                                                         AND Container.DescId  = zc_Container_CountPartionDate()
                                                         AND Container.Amount > 0

                                     LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                  AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                     LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                          ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                         AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                             ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                            AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                 )

       , tmpContainerPD AS (SELECT Container.ParentId
                                 , Container.PartionDateKindId
                                 , Sum(Container.Amount)          AS Amount
                            FROM tmpContainerPDAll AS Container
                            GROUP BY Container.ParentId
                                   , Container.PartionDateKindId
                             )
       , tmpTo AS (SELECT SUM (COALESCE (tmpContainerPD.Amount, Container.Amount)) AS Amount
                   FROM tmpContainer AS Container

                        LEFT OUTER JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.ID

                   WHERE Container.NDSKindId                           = inNDSKindId
                     AND COALESCE(Container.DivisionPartiesId, 0)      = COALESCE(inDivisionPartiesId, 0)
                     AND COALESCE(Container.JuridicalId, 0)            = vbJuridicalId
                     AND COALESCE(tmpContainerPD.PartionDateKindId, 0) = COALESCE (inPartionDateKindId, 0)
                  )
    SELECT Amount
    INTO outAmount
    FROM tmpTo;
                  
    IF outAmount >= inAmount
    THEN
      outJuridicalId := vbJuridicalId;
      outJuridicalName := (SELECT ValueData FROM Object WHERE ID = vbJuridicalId);
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.11.16                                        *
*/

-- тест

select * from gpGet_Movement_Check_PairSunAmount(inGoodsId := 596529 , inNDSKindId := 9 , inPartionDateKindId := 0 , inDivisionPartiesId := 0 , inAmount := 1 ,  inSession := '3');