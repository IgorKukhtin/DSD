-- Function: zfGet_JuridicalList

DROP FUNCTION IF EXISTS zfGet_JuridicalList (Integer, Integer, TFloat);
DROP FUNCTION IF EXISTS zfGet_JuridicalList (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION zfGet_JuridicalList (
    IN inGoodsId Integer  , -- Идентификатор товара
    IN inAmount  TFloat   , -- Кол-во товара, которое должно быть на остатках
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TBlob
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId Integer;
   DECLARE vbRec RECORD;
   DECLARE vbAmount TFloat;
   DECLARE vbSum TFloat;
   DECLARE vbJuridicalList TBlob;
BEGIN
      vbUserId:= lpGetUserBySession (inSession);
      vbUnitKey:= COALESCE (lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
      IF vbUnitKey = '' 
      THEN
           vbUnitKey:= '0';
      END IF;   
      vbUnitId:= vbUnitKey::Integer;

      IF COALESCE (inGoodsId, 0) <> 0 AND COALESCE (vbUnitId, 0) <> 0 AND inAmount > 0
      THEN
           CREATE TEMP TABLE tmpJList(JuridicalName TBlob, Amount TFloat) ON COMMIT DROP;

           vbAmount:= inAmount;

           FOR vbRec IN 
               SELECT COALESCE (Object_Juridical.ValueData, '')::TBlob AS JuridicalName
                    , Container.Amount
               FROM Container
                    -- партия
                    JOIN ContainerLinkObject AS CLO_PartionMovementItem
                                             ON CLO_PartionMovementItem.ContainerId = Container.Id
                                            AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                    JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
                    -- элемент прихода
                    JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                    JOIN Movement ON Movement.Id = MovementItem.MovementId
                    JOIN MovementLinkObject AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                    JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_From.ObjectId
               WHERE Container.DescId = zc_Container_Count()
                 AND Container.WhereObjectId = vbUnitId
                 AND Container.ObjectId = inGoodsId
                 AND Container.Amount > 0
               ORDER BY Movement.OperDate
           LOOP
                IF vbAmount >= vbRec.Amount
                THEN
                     vbAmount:= vbAmount - vbRec.Amount;
                     vbSum:= vbRec.Amount;
                ELSIF vbAmount < vbRec.Amount AND vbAmount > 0 
                THEN
                     vbSum:= vbAmount;
                     vbAmount:= 0;
                ELSE
                     vbSum:= 0; 
                END IF;

                IF vbSum > 0 
                THEN
                     UPDATE tmpJList SET Amount = Amount + vbSum WHERE JuridicalName = vbRec.JuridicalName;

                     IF NOT FOUND
                     THEN
                          INSERT INTO tmpJList VALUES (vbRec.JuridicalName, vbSum);
                     END IF;
                END IF;
           END LOOP;             
      END IF;

      SELECT string_agg (JuridicalName || ' (' || Amount || ')', ', ') INTO vbJuridicalList FROM tmpJList;

      RETURN COALESCE (vbJuridicalList, '')::TBlob;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Ярошенко Р.Ф.
 08.05.17                                                                       *  
*/

-- тест
-- SELECT zfGet_JuridicalList (inGoodsId:= 25441, inAmount:= 1, inSession:= zfCalc_UserAdmin());
