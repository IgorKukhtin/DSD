-- Function: gpSelect_MovementItem_PUSHCreatePretension()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PUSHCreatePretension (Integer, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PUSHCreatePretension(
    IN inMovementId        Integer  , -- ключ Документа
    IN inJSON              Text     , -- json     
   OUT outShowMessage      Boolean  , -- Показыват сообщение
   OUT outPUSHType         Integer  , -- Тип сообщения
   OUT outText             Text     , -- Текст сообщения
   OUT outSpecialLighting  Boolean ,      -- 
   OUT outTextColor        Integer ,      -- 
   OUT outColor            Integer ,      -- 
   OUT outBold             Boolean ,      -- 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbText  Text;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    outShowMessage := False;
    outSpecialLighting  := True;
    outTextColor        := zc_Color_Red();
    outColor            := zc_Color_White();
    outBold             := True;

    IF COALESCE (inJSON, '') = ''
    THEN
      RETURN;
    END IF;

    IF EXISTS(SELECT  1
              FROM MovementLinkMovement AS MLMovement_Income
              
                   INNER JOIN Movement ON Movement.Id = MLMovement_Income.MovementId
                                      AND Movement.DescId = zc_Movement_Pretension()
                                      AND Movement.StatusId = zc_Enum_Status_UnComplete() 
              
              WHERE MLMovement_Income.MovementChildId = inMovementID
                AND MLMovement_Income.DescId = zc_MovementLinkMovement_Income())
    THEN
        
      -- таблица
      CREATE TEMP TABLE _tmpGoods (id Integer
                                 , GoodsId Integer
                                 , ReasonDifferencesId Integer
                                 , Amount TFloat) ON COMMIT DROP;

      INSERT INTO _tmpGoods
      SELECT *
      FROM json_populate_recordset(null::_tmpGoods, replace(replace(replace(inJSON, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
	  
	  ANALYSE _tmpGoods;

      WITH tmpMovement AS (SELECT Movement.Id
                                , '№ '||Movement.InvNumber||' от '||to_char(Movement.OperDate, 'DD.MM.YYYY') AS Pretension
                           FROM MovementLinkMovement AS MLMovement_Income
                            
                                INNER JOIN Movement ON Movement.Id = MLMovement_Income.MovementId
                                                   AND Movement.DescId = zc_Movement_Pretension()
                                                   AND Movement.StatusId = zc_Enum_Status_UnComplete() 
                            
                           WHERE MLMovement_Income.MovementChildId = inMovementID
                             AND MLMovement_Income.DescId = zc_MovementLinkMovement_Income()
                          )
         , tnpMI AS (SELECT  Movement_Pretension.Id
                           , string_agg('    '||Object_Goods.ObjectCode::tvarchar||' - '||
                            Object_Goods.ValueData||'; '||zfConvert_FloatToString(MI_Pretension.Amount)||' - '||
                            Object_ReasonDifferences.ValueData, chr(13)) AS MIData
                     FROM tmpMovement AS Movement_Pretension
                          INNER JOIN MovementItem AS MI_Pretension
                                                  ON MI_Pretension.MovementId = Movement_Pretension.Id
                                                 AND MI_Pretension.isErased  = FALSE
                                                 AND MI_Pretension.DescId     = zc_MI_Master()
                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Pretension.ObjectId
                          
                          INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MI_Pretension.ObjectId

                          INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                         ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                                        AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                        AND MIBoolean_Checked.ValueData = TRUE
    
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                           ON MILinkObject_ReasonDifferences.MovementItemId = MI_Pretension.Id
                                                          AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                                                          
                                                          
                          LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MILinkObject_ReasonDifferences.ObjectId
                     GROUP BY Movement_Pretension.Id)   
                          
      SELECT string_agg(Pretension||chr(13)||tnpMI.MIData, chr(13))
      INTO vbText
      FROM tmpMovement
           INNER JOIN tnpMI ON tnpMI.ID = tmpMovement.Id
      ;  

      IF COALESCE (vbText, '') <> ''
      THEN
        outShowMessage := True;
        outPUSHType := zc_TypePUSH_Confirmation();
        outText := 'ВНИМАНИЕ !!!'||chr(13)||chr(13)||'По этой приходной накладной у вас создана претензия c выбранным товаром  '||chr(13)||vbText||chr(13)||chr(13)||
                   'ПРОВЕРЬТЕ , возможно  - ВЫ ДУБЛИРУЕТЕ ПРЕТЕНЗИЮ !!!!';
      END IF;
      
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.11.16                                                       *
*/

-- тест

select * from gpSelect_MovementItem_PUSHCreatePretension(inMovementID := 26168478 , inJSON := '[{"id":480522929,"goodsid":2452,"reasondifferencesid":null,"amount":0},{"id":480522932,"goodsid":18508,"reasondifferencesid":null,"amount":0},{"id":480522930,"goodsid":27949,"reasondifferencesid":null,"amount":0},{"id":480522933,"goodsid":37759,"reasondifferencesid":1235047,"amount":1},{"id":480522931,"goodsid":46480,"reasondifferencesid":null,"amount":0}]' ,  inSession := '3');