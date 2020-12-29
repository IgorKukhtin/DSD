-- Function: gpSelect_Cash_ShowPUSH_UKTZED(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Cash_ShowPUSH_UKTZED(integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_ShowPUSH_UKTZED(
    IN inGoodsId        integer,          -- Товар
   OUT outShowMessage   Boolean,          -- Показыват сообщение
   OUT outPUSHType      Integer,          -- Тип сообщения
   OUT outText          Text,             -- Текст сообщения
    IN inSession        TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbName  TVarChar;
   DECLARE vbJuridical Integer;
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
    
  outShowMessage := True;
  outPUSHType := 3;
  outText := '';

  IF EXISTS(SELECT * FROM Container

                 LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                               ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                              AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                 LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                         ON ObjectBoolean_BanFiscalSale.ObjectId = ContainerLinkObject_DivisionParties.ObjectId
                                        AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()
            WHERE Container.ObjectId = inGoodsId
              AND Container.DescId = zc_Container_Count()
              AND Container.Amount > 0
              AND COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = FALSE)
  THEN
    WITH tmpContainer AS (SELECT zfConvert_FloatToString(SUM(Container.Amount))||'уп.  '||Object_Unit.ValueData||
                                 CASE WHEN Container.WhereObjectId = vbUnitId THEN ' (можете опустить эту позицию без УКТВЭД и пробить обычным фискальным чеком)' ELSE '' END AS ValueData
                          FROM Container

                               LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = Container.WhereObjectId

                               LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                             ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                            AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                                       ON ObjectBoolean_BanFiscalSale.ObjectId = ContainerLinkObject_DivisionParties.ObjectId
                                                      AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()

                          WHERE Container.ObjectId = inGoodsId
                            AND Container.DescId = zc_Container_Count()
                            AND Container.Amount <> 0
                            AND COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = FALSE
                          GROUP BY Container.WhereObjectId, Object_Unit.ValueData)

    SELECT string_agg(tmpContainer.ValueData, Chr(13))
    INTO outText
    FROM tmpContainer;
  END IF;

  outText := 'Товар <'||(SELECT Object.ValueData FROM Object WHERE Object.ID = inGoodsId)||
             '> из выбранной партии по техническим причинам пробивается по служебному чеку (зеленая галка)...'||
             CASE WHEN outText <> '' THEN Chr(13)||Chr(13)||'Если клиент просит фискальный чек на товар, то вот список аптек, где данный товар смогут отпустить по фискальному чеку:'||Chr(13)||outText ELSE '' END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.10.20                                                       *

*/

-- select * from gpSelect_Cash_ShowPUSH_UKTZED(inGoodsId := 3586  ,  inSession := '3');