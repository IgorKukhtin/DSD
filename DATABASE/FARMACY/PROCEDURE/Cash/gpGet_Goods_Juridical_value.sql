-- Function: gpGet_Goods_Juridical_value()

--DROP FUNCTION IF EXISTS gpGet_Goods_Juridical_value (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Goods_Juridical_value (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Goods_Juridical_value(
    IN inGoodsId       Integer    , --
    IN inAmount        TFloat    , --
   OUT outJuridicalID  Integer   , --
   OUT outCodeRazom    Integer   , --
    IN inSession       TVarChar    --
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    WITH
        tmpContainerAll AS (SELECT Container.Id
                                 , Container.Amount
                                 , Object_Goods.ValueData ILIKE '%аббот%' AS NotReplace
                               FROM Container
                                    LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId
                               WHERE Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.ObjectId = inGoodsId
                              )
       , tmpContainer AS (SELECT Container.id
                               , inAmount                                               AS SaleAmount
                               , Container.Amount                                       AS ContainerAmount
                               , MovementLinkObject_From.ObjectId                       AS JuridicalID
                               , COALESCE(ObjectFloat_CodeRazom.ValueData, CASE WHEN Container.NotReplace THEN NULL ELSE 1 END)::Integer  AS CodeRazom
                               , SUM (Container.Amount) OVER (ORDER BY Movement.OperDate, Container.Id) AS ContainerAmountSUM
                               , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC, Container.Id DESC) AS DOrd
                           FROM tmpContainerAll AS Container
                                LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                              ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                             AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                -- элемент прихода
                                LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                INNER JOIN Movement ON Movement.Id = MI_Income.MovementId
                                -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                            ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                           AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                     -- AND 1=0

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                LEFT JOIN ObjectFloat AS ObjectFloat_CodeRazom
                                                      ON ObjectFloat_CodeRazom.ObjectId = MovementLinkObject_From.ObjectId
                                                     AND ObjectFloat_CodeRazom.DescId = zc_ObjectFloat_Juridical_CodeRazom()
                          ORDER BY Movement.OperDate, Container.Id
                                 )
       , tmpContainerUsed AS (SELECT Container.JuridicalID
                                   , Container.CodeRazom
                                   , CASE WHEN Container.SaleAmount - Container.ContainerAmountSUM > 0 AND Container.DOrd <> 1
                                               THEN Container.ContainerAmount
                                          ELSE Container.SaleAmount - Container.ContainerAmountSUM + Container.ContainerAmount
                                     END AS Amount
                              FROM tmpContainer AS Container
                              WHERE Container.SaleAmount - (Container.ContainerAmountSUM - Container.ContainerAmount) > 0)

       SELECT Container.JuridicalID, Container.CodeRazom
       INTO outJuridicalID, outCodeRazom
       FROM tmpContainerUsed AS Container
       WHERE NOT EXISTS(SELECT 1 FROM tmpContainerUsed WHERE COALESCE(tmpContainerUsed.CodeRazom, 0) = 0)
       LIMIT 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Goods_Juridical_value (Integer, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.04.20                                                       *
 19.11.19                                                       *
*/

-- тест
-- SELECT * from gpGet_Goods_Juridical_value (inGoodsId:= 5925280, inAmount := 1, inSession:= zfCalc_UserAdmin())

