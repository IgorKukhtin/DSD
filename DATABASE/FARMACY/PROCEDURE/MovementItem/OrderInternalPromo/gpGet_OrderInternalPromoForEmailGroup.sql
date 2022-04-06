-- Function: gpGet_OrderInternalPromoForEmailGroup()

DROP FUNCTION IF EXISTS gpGet_OrderInternalPromoForEmailGroup(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderInternalPromoForEmailGroup(
    IN inMovementId  Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)

RETURNS TABLE (Subject TVarChar, Body TBlob, AddressFrom TVarChar, AddressTo TVarChar
             , Host TVarChar, Port Integer, UserName TVarChar, Password TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbMail TVarChar;
  DECLARE vbSubject TVarChar;
  DECLARE vbZakazName TVarChar;
  DECLARE vbBody Text;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);


   -- еще
   SELECT Movement.InvNumber
   INTO vbInvNumber
   FROM Movement
   WHERE Movement.ID = inMovementId;
   
   vbMail := 'pravda@neboley.dp.ua';          
   
   vbSubject := 'Заказ по маркетингу #1#';
   
   
   WITH
        -- строки чайлд
        tmpMI_Child AS (SELECT MovementItem.Id
                             , MovementItem.ParentId
                             , MovementItem.ObjectId                       
                             , MovementItem.Amount              AS Amount
                             , MIFloat_AmountManual.ValueData   AS AmountManual
                        FROM MovementItem

                             LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId = zc_MI_Child()
                          AND MovementItem.isErased = FALSE
                        ),
        tmpOF_NDSKind_NDS AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId, ObjectFloat_NDSKind_NDS.valuedata FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                              WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                              ),
        tmpMI_All AS (SELECT Object_Juridical.ValueData                           AS JuridicalMainName
                           , OIP_Master.JuridicalName                             AS JuridicalName
                           , SUM(ROUND(OIP_Child.Amount * OIP_Master.Price * (1.0 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 7) / 100), 2))   AS Summa
                      FROM gpSelect_MI_OrderInternalPromo(inMovementId := inMovementId , inIsErased := 'False' ,  inSession := '3') as OIP_Master

                           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = OIP_Master.GoodsId
                           INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId 

                           LEFT JOIN tmpOF_NDSKind_NDS AS ObjectFloat_NDSKind_NDS
                                                       ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId

                           INNER JOIN tmpMI_Child AS OIP_Child 
                                                  ON OIP_Child.ParentId = OIP_Master.Id
                                      
                           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical 
                                                 ON ObjectLink_Unit_Juridical.ObjectId = OIP_Child.ObjectId
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                      WHERE COALESCE(OIP_Master.JuridicalId, 0) <> 0
                      GROUP BY Object_Juridical.ValueData
                             , OIP_Master.JuridicalName
                      HAVING SUM(ROUND(OIP_Child.Amount * OIP_Master.Price, 2)) > 0
                      ),
        tmpSUM AS (SELECT tmpMI_All.JuridicalMainName
                        , string_agg('         '||tmpMI_All.JuridicalName||'  '||zfConvert_FloatToString(tmpMI_All.Summa)||' грн.', chr(13)) AS SumJuridical

                   FROM tmpMI_All      
                   GROUP BY tmpMI_All.JuridicalMainName)
                   
    SELECT string_agg(tmpSUM.JuridicalMainName||chr(13)||tmpSUM.SumJuridical, chr(13))
    INTO vbBody
    FROM tmpSUM;   

    -- Временно для теста
    IF vbUserId = 3
    THEN
      vbMail := 'olegsh1264@gmail.com,palladino27@gmail.com';
    END IF;
    
    -- Результат
    RETURN QUERY
       WITH tmpComment AS (SELECT MS_Comment.ValueData AS Comment FROM MovementString AS MS_Comment WHERE MS_Comment.MovementId = inMovementId AND MS_Comment.DescId = zc_MovementString_Comment())
          , tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= inSession) AS tmp WHERE tmp.EmailKindId = zc_Enum_EmailKind_OutOrder())
       SELECT
         -- Тема
         REPLACE (vbSubject, '#1#', '#' || vbInvNumber || '#') :: TVarChar AS Subject

         -- Body
       , vbBody :: TBlob AS Body

         -- Body
       , zc_Mail_From()              AS AddressFrom   
       , vbMail                      AS AddressTo
       
       , zc_Mail_Host():: TVarChar AS Host
       , zc_Mail_Port():: Integer AS Port
       , zc_Mail_User():: TVarChar AS UserName
       , zc_Mail_Password():: TVarChar AS Password
       
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.08.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpGet_OrderInternalPromoForEmailGroup (inMovementId := 26605995   , inSession:= '3');