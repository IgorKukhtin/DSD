-- Function: gpGet_Movement_Promo()

--DROP FUNCTION IF EXISTS gpGet_Movement_Promo (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Promo (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Promo(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inMask              Boolean  , -- добавить по маске
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , InvNumber        Integer    --Номер документа
             , InvNumberFull    TVarChar   --Номер документа + дата
             , OperDate         TDateTime   --Дата документа
             , StatusCode       Integer     --код статуса
             , StatusName       TVarChar    --Статус     
             , PaidKindId Integer, PaidKindName TVarChar
             , PromoKindId      Integer     --Вид акции
             , PromoKindName    TVarChar    --Вид акции
             , PromoStateKindId Integer     -- Состояние Акции
             , PromoStateKindName TVarChar  -- Состояние Акции
             , PriceListId      Integer     --прайс лист
             , PriceListName    TVarChar    --Прайс лист
             , StartPromo       TDateTime   --Дата начала акции
             , EndPromo         TDateTime   --Дата окончания акции
             , StartSale        TDateTime   --Дата начала отгрузки по акционной цене
             , EndSale          TDateTime   --Дата окончания отгрузки по акционной цене
             , EndReturn        TDateTime   --Дата окончания возвратов по акционной цене
             , OperDateStart    TDateTime   --Дата начала расч. продаж до акции
             , OperDateEnd      TDateTime   --Дата окончания расч. продаж до акции
             , MonthPromo       TDateTime   --Месяц акции
             , CheckDate        TDateTime   --Дата Согласования  
             , ServiceDate      TDateTime   --Месяц расчета с/с
             , CostPromo        TFloat      --Стоимость участия в акции
             , ChangePercent    TFloat      --(-)% Скидки (+)% Наценки по договору

             , Comment          TVarChar    --Примечание
             , CommentMain      TVarChar    --Примечание (Общее)
             , UnitId           INTEGER     --Подразделение
             , UnitName         TVarChar    --Подразделение
             , PersonalTradeId  INTEGER     --Ответственный представитель коммерческого отдела
             , PersonalTradeName TVarChar   --Ответственный представитель коммерческого отдела
             , PersonalId       INTEGER     --Ответственный представитель маркетингового отдела	
             , PersonalName     TVarChar    --Ответственный представитель маркетингового отдела	
             , SignInternalId   Integer
             , SignInternalName TVarChar
             , isPromo          Boolean     --Акция (да/нет)   
             , isCost           Boolean     --Затраты
             , Checked          Boolean     --Согласовано (да/нет)
             , isTaxPromo       Boolean     -- схема % скидки
             , isTaxPromo_Condition  Boolean     -- схема % компенсации
             , isPromoStateKind   Boolean      -- Приоритет для состояния
             , strSign          TVarChar    -- ФИО пользователей. - есть эл. подпись
             , strSignNo        TVarChar    -- ФИО пользователей. - ожидается эл. подпись 
             
             , OperDateOrder_text TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbSignInternalId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Promo());
    -- vbUserId:= lpGetUserBySession (inSession);

    --IF NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
     -- создаем док по маске
     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_Promo_Mask (ioId        := inMovementId
                                                 , inOperDate  := inOperDate
                                                 , inSession   := inSession); 
     END IF;

    IF COALESCE (inMovementId, 0) < 0
    THEN
        RAISE EXCEPTION 'Ошибка. Невозможно открыть пустой документ.';
    END IF;


    IF COALESCE (inMovementId, 0) = 0
    THEN
        -- данные из Модели для данного документа
        vbSignInternalId := (SELECT DISTINCT tmp.SignInternalId
                             FROM lpSelect_Object_SignInternalItem ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_SignInternal())
                                                                  , (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId)
                                                                  , 0, 0) AS tmp
                            );
        -- Результат
        RETURN QUERY
        SELECT
            0                                                 AS Id
          , CAST (NEXTVAL ('movement_Promo_seq') AS Integer)  AS InvNumber
          , ''  :: TVarChar                                   AS InvNumberFull
          , inOperDate	                                      AS OperDate
          , Object_Status.Code                                AS StatusCode
          , Object_Status.Name                                AS StatusName 
          , NULL::Integer                                     AS PaidKindId
          , NULL::TVarChar                                    AS PaidKindName
          , NULL::Integer                                     AS PromoKindId         --Вид акции
          , NULL::TVarChar                                    AS PromoKindName       --Вид акции
          , 0                                                 AS PromoStateKindId        --Состояние акции
          , NULL::TVarChar                                    AS PromoStateKindName      --Состояние акции

          , Object_PriceList.Id                               AS PriceListId         --Прайс лист
          , Object_PriceList.ValueData                        AS PriceListName       --Прайс лист
          , NULL::TDateTime                                   AS StartPromo          --Дата начала акции
          , NULL::TDateTime                                   AS EndPromo            --Дата окончания акции
          , NULL::TDateTime                                   AS StartSale           --Дата начала отгрузки по акционной цене
          , NULL::TDateTime                                   AS EndSale             --Дата окончания отгрузки по акционной цене
          , NULL::TDateTime                                   AS EndReturn           --Дата окончания возвратов по акционной цене
          , NULL::TDateTime                                   AS OperDateStart       --Дата начала расч. продаж до акции
          , NULL::TDateTime                                   AS OperDateEnd         --Дата окончания расч. продаж до акции
          , NULL::TDateTime                                   AS MonthPromo          --Месяц акции 
          , inOperDate                                        AS CheckDate           --Дата Согласования
          , NULL:: TDateTime                                  AS ServiceDate
          , NULL::TFloat                                      AS CostPromo           --Стоимость участия в акции
          , NULL::TFloat                                      AS ChangePercent       --(-)% Скидки (+)% Наценки по договору
          , NULL::TVarChar                                    AS Comment             --Примечание
          , NULL::TVarChar                                    AS CommentMain         --Примечание (Общее)
          , NULL::Integer                                     AS UnitId              --Подразделение
          , NULL::TVarChar                                    AS UnitName            --Подразделение
          , NULL::Integer                                     AS PersonalTradeId     --Ответственный представитель коммерческого отдела
          , NULL::TVarChar                                    AS PersonalTradeName   --Ответственный представитель коммерческого отдела
          , NULL::Integer                                     AS PersonalId          --Ответственный представитель маркетингового отдела	
          , NULL::TVarChar                                    AS PersonalName        --Ответственный представитель маркетингового отдела
          , Object_SignInternal.Id                            AS SignInternalId
          , Object_SignInternal.ValueData :: TVarChar         AS SignInternalName
             
          , CAST (TRUE  AS Boolean)                           AS isPromo
          , CAST (FALSE AS Boolean)                           AS isCost
          , CAST (FALSE AS Boolean)                           AS Checked
          , CAST (FALSE AS Boolean)                           AS isTaxPromo            -- схема % скидки
          , CAST (FALSE AS Boolean)                           AS isTaxPromo_Condition  -- схема % компенсации
          , CAST (FALSE AS Boolean)                           AS isPromoStateKind  -- Приоритет для состояния
          , NULL::TVarChar                                    AS strSign
          , NULL::TVarChar                                    AS strSignNo
          , NULL::TVarChar                                    AS OperDateOrder_text 
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            LEFT OUTER JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
            LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = vbSignInternalId
        ;
    ELSE
        RETURN QUERY
        WITH
        tmpOperDateOrder AS (SELECT STRING_AGG (DISTINCT CASE WHEN COALESCE (ObjectBoolean_OperDateOrder.ValueData, FALSE ) = TRUE THEN  'Заявка' ELSE 'Отгрузка' END , ';') AS OperDateOrder_text
                             FROM Movement AS Movement_Promo 
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                              ON MovementLinkObject_Partner.MovementId = Movement_Promo.Id
                                                             AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()

                                 LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                            ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_Partner.ObjectId
                                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                                 LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                            ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_Partner.ObjectId)
                                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                                         ON ObjectBoolean_OperDateOrder.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                        AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()

                             WHERE Movement_Promo.DescId = zc_Movement_PromoPartner()
                               AND Movement_Promo.ParentId = inMovementId
                             ) 

        SELECT
            Movement_Promo.Id                 --Идентификатор
          , Movement_Promo.InvNumber          --Номер документа
          , ('№ ' || Movement_Promo.InvNumber || ' от ' || zfConvert_DateToString (Movement_Promo.OperDate)  ) :: TVarChar AS InvNumberFull
          , Movement_Promo.OperDate           --Дата документа
          , Movement_Promo.StatusCode         --код статуса
          , Movement_Promo.StatusName         --Статус  
          , Movement_Promo.PaidKindId        --
          , Movement_Promo.PaidKindName        --
          , Movement_Promo.PromoKindId        --Вид акции
          , Movement_Promo.PromoKindName      --Вид акции
          , Movement_Promo.PromoStateKindId   --Состояние акции
          , Movement_Promo.PromoStateKindName --Состояние акции
          , Movement_Promo.PriceListId        --
          , Movement_Promo.PriceListName      --
          , Movement_Promo.StartPromo         --Дата начала акции
          , Movement_Promo.EndPromo           --Дата окончания акции
          , Movement_Promo.StartSale          --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --Дата окончания отгрузки по акционной цене
          , Movement_Promo.EndReturn          --Дата окончания возвратов по акционной цене
          , Movement_Promo.OperDateStart      --Дата начала расч. продаж до акции
          , Movement_Promo.OperDateEnd        --Дата окончания расч. продаж до акции
          , Movement_Promo.MonthPromo         -- месяц акции
          , Movement_Promo.CheckDate          --Дата Согласования    
          , Movement_Promo.ServiceDate        --Месяц расчета с/с
          , Movement_Promo.CostPromo          --Стоимость участия в акции
          , Movement_Promo.ChangePercent      --(-)% Скидки (+)% Наценки по договору
          , Movement_Promo.Comment            --Примечание
          , Movement_Promo.CommentMain        --Примечание (Общее)
          , Movement_Promo.UnitId             --Подразделение
          , Movement_Promo.UnitName           --Подразделение
          , Movement_Promo.PersonalTradeId    --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalTradeName  --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalId         --Ответственный представитель маркетингового отдела	
          , Movement_Promo.PersonalName       --Ответственный представитель маркетингового отдела
          , COALESCE (Movement_Promo.SignInternalId, Object_SignInternal.Id)          AS SignInternalId
          , COALESCE (Movement_Promo.SignInternalName, Object_SignInternal.ValueData) AS SignInternalName
          , Movement_Promo.isPromo            --Акция
          , Movement_Promo.isCost                   --Затраты
          , Movement_Promo.Checked            --согласовано
          , Movement_Promo.isTaxPromo
          , Movement_Promo.isTaxPromo_Condition
          , Movement_Promo.isPromoStateKind :: Boolean AS isPromoStateKind  -- Приоритет для состояния

          , tmpSign.strSign
          , tmpSign.strSignNo  
          
          , tmpOperDateOrder.OperDateOrder_text ::TVarChar           
        FROM Movement_Promo_View AS Movement_Promo
             LEFT JOIN lpSelect_MI_Sign (inMovementId:= Movement_Promo.Id ) AS tmpSign ON tmpSign.Id = Movement_Promo.Id   -- эл.подписи  --
             LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = tmpSign.SignInternalId
             LEFT JOIN tmpOperDateOrder ON 1 = 1
        WHERE Movement_Promo.Id =  inMovementId
        LIMIT 1;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 01.05.23         *
 07.05.21         * add inMask
 13.07.20         * ChangePercent
 01.04.20         *
 01.08.17         * CheckedDate
 25.07.17         *
 13.10.15                                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Promo (inMovementId:= 1, inOperDate:= '30.11.2015', inMask:= False, inSession:= zfCalc_UserAdmin())
--select * from gpGet_Movement_Promo(inMovementId := 29044450 , inOperDate := ('01.11.2024')::TDateTime , inMask := 'False' ,  inSession := '9457');