-- View: _bi_Doc_OrderExternal_View

DROP VIEW IF EXISTS _bi_Doc_OrderExternal_View;

/*
-- Документ - Заявки сторонние
-- данные:
  --Документ Заявки сторонние
Id
InvNumber
OperDate 
--Вид статуса
StatusCode
StatusName
--Дата отгрузки контрагенту
OperDatePartner
--Дата маркировки
OperDateMark
--Номер заявки у контрагента
InvNumberPartner
--Подразделения (другой филиал) / Контрагент
FromId
FromName
--Подразделение (другой филиал) / Подразделение
ToId
ToName
--Физические лица(экспедитор)
PersonalId
PersonalName
--Маршрут
RouteId
RouteName 
--Сортировки маршрутов
RouteSortingId
RouteSortingName
--Виды форм оплаты 
PaidKindId
PaidKindName
--Договор
ContractId
ContractCode
ContractName
ContractTagName
--Прайс-лист
PriceListId
PriceListName
--Контрагент
PartnerId
PartnerName
--Торговая сеть
RetailId
RetailName
--Информация по отгрузке
CarInfoId
CarInfoName
--Примечание к отгрузке
CarComment
--Дата/время отгрузки
OperDate_CarInfo
--Цена с НДС (да/нет)
PriceWithVAT
--был ли распечатан документ (да/нет)
isPrinted
--печатать Примечание в Расходной накладной
isPrintComment
--% НДС
VATPercent
--(-)% Скидки (+)% Наценки
ChangePercent
--Итого сумма по накладной (без НДС)
TotalSummMVAT
--Итого сумма по накладной (с НДС)
TotalSummPVAT
--Итого сумма по накладной (с учетом НДС и скидки)
TotalSumm
--Итого количество, кг
TotalCountKg
--Итого количество, шт
TotalCountSh
--Итого количество
TotalCount
--Итого количество дозаказ
TotalCountSecond
--Документ EDI
MovementId_EDI
--Был сформирован резерв
IsRemains
--Есть ли товары с акцией в документе
isPromo
--документ Акция
MovementPromo
--Комментарий
Comment
--М Пользователи
InsertName
--М Дата/время создания документа
InsertDate
--М Дата/время создания на моб устр.
InsertMobileDate
--М Глобальный уникальный идентификатор
GUID
--Протокол Дата/время начало
StartBegin
--Протокол Дата/время завершение
EndBegin
--Виды статусов wms
StatusId_wms
StatusCode_wms
StatusName_wms

-- Id строки
MovementItemId
--Удалена строка (Да/нет)
isErased_mi
--товар
GoodsId
--Вид товара
GoodsKindId
--Количество
Amount
--Цена
Price
--Цена из Эксайта
PriceEDI
--Цена за количество
CountForPrice
--(-)% Скидки (+)% Наценки
ChangePercent_mi
--Количество дозаказ
AmountSecond
--Сумма с ндс и скидкой
Summ
--MovementId-Акция
MovementId_Promo
--Протокол Дата/время начало
StartBegin_mi
--Протокол Дата/время завершение
EndBegin_mi
*/


CREATE OR REPLACE VIEW _bi_Doc_OrderExternal_View
AS

       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate 
           --Вид статуса
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           --Дата отгрузки контрагенту
           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           --Дата маркировки
           , MovementDate_OperDateMark.ValueData            AS OperDateMark
           --Номер заявки у контрагента
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
           --Подразделения (другой филиал) / Контрагент
           , Object_From.Id                                 AS FromId
           , Object_From.ValueData                          AS FromName
           --Подразделение (другой филиал) / Подразделение
           , Object_To.Id                                   AS ToId
           , Object_To.ValueData                            AS ToName
           --Физические лица(экспедитор)
           , Object_Personal.Id                             AS PersonalId
           , Object_Personal.ValueData                      AS PersonalName
           --Маршрут
           , Object_Route.Id                                AS RouteId
           , Object_Route.ValueData                         AS RouteName 
           --Сортировки маршрутов
           , Object_RouteSorting.Id                         AS RouteSortingId
           , Object_RouteSorting.ValueData                  AS RouteSortingName
           --Виды форм оплаты 
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           --Договор
           , View_Contract_InvNumber.ContractId             AS ContractId
           , View_Contract_InvNumber.ContractCode           AS ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractName
           , View_Contract_InvNumber.ContractTagName        AS ContractTagName
           --Прайс-лист
           , Object_PriceList.id                            AS PriceListId
           , Object_PriceList.ValueData                     AS PriceListName
           --Контрагент
           , Object_Partner.id                              AS PartnerId
           , Object_Partner.ValueData                       AS PartnerName
           --Торговая сеть
           , Object_Retail.Id                               AS RetailId
           , Object_Retail.ValueData                        AS RetailName
           --Информация по отгрузке
           , Object_CarInfo.Id                              AS CarInfoId
           , Object_CarInfo.ValueData                       AS CarInfoName
           --Примечание к отгрузке
           , MovementString_CarComment.ValueData ::TVarChar AS CarComment
           --Дата/время отгрузки
           , MovementDate_CarInfo.ValueData     ::TDateTime AS OperDate_CarInfo
           --Цена с НДС (да/нет)
           , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
           --был ли распечатан документ (да/нет)
           , COALESCE (MovementBoolean_Print.ValueData, False) AS isPrinted
           --печатать Примечание в Расходной накладной
           , COALESCE (MovementBoolean_PrintComment.ValueData, FALSE) AS isPrintComment
           --% НДС
           , MovementFloat_VATPercent.ValueData             AS VATPercent
           --(-)% Скидки (+)% Наценки
           , MovementFloat_ChangePercent.ValueData          AS ChangePercent
           --Итого сумма по накладной (без НДС)
           , MovementFloat_TotalSummMVAT.ValueData          AS TotalSummMVAT
           --Итого сумма по накладной (с НДС)
           , MovementFloat_TotalSummPVAT.ValueData          AS TotalSummPVAT
           --Итого сумма по накладной (с учетом НДС и скидки)
           , MovementFloat_TotalSumm.ValueData              AS TotalSumm
           --Итого количество, кг
           , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
           --Итого количество, шт
           , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh
           --Итого количество
           , MovementFloat_TotalCount.ValueData             AS TotalCount
           --Итого количество дозаказ
           , MovementFloat_TotalCountSecond.ValueData       AS TotalCountSecond
           --Документ EDI
           , MovementLinkMovement_Order.MovementId          AS MovementId_EDI
           --Был сформирован резерв
           , COALESCE (MovementBoolean_Remains.ValueData, FALSE) ::Boolean AS IsRemains
           --Есть ли товары с акцией в документе
           , COALESCE (MovementBoolean_Promo.ValueData, FALSE) AS isPromo
           --документ Акция
           , zfCalc_PromoMovementName (NULL, Movement_Promo.InvNumber :: TVarChar, Movement_Promo.OperDate, MD_StartSale.ValueData, MD_EndSale.ValueData) AS MovementPromo
           --Комментарий
           , MovementString_Comment.ValueData       AS Comment
           --М Пользователи
           , Object_User.ValueData                  AS InsertName
           --М Дата/время создания документа
           , MovementDate_Insert.ValueData          AS InsertDate
           --М Дата/время создания на моб устр.
           , MovementDate_InsertMobile.ValueData    AS InsertMobileDate
           --М Глобальный уникальный идентификатор
           , MovementString_GUID.ValueData :: TVarChar AS GUID
           --Протокол Дата/время начало
           , MovementDate_StartBegin.ValueData  AS StartBegin
           --Протокол Дата/время завершение
           , MovementDate_EndBegin.ValueData    AS EndBegin
           ----Виды статусов wms
           , Object_Status_wms.Id                       AS StatusId_wms
           , Object_Status_wms.ObjectCode               AS StatusCode_wms
           , Object_Status_wms.ValueData                AS StatusName_wms
           --
           , MovementItem.Id                              AS MovementItemId
           --Удалена строка (Да/нет)
           , MovementItem.isErased                        AS isErased_mi
           --товар
           , MovementItem.ObjectId                        AS GoodsId
           --Вид товара
           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
           --Количество
           , MovementItem.Amount                           AS Amount
           --Цена
           , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
           --Цена из Эксайта
           , COALESCE (MIFloat_PriceEDI.ValueData, 0)      AS PriceEDI
           --Цена за количество
           , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
           --(-)% Скидки (+)% Наценки
           , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent_mi
           --Количество дозаказ
           , MIFloat_AmountSecond.ValueData                AS AmountSecond
           --Сумма с ндс и скидкой
           , MIFloat_Summ.ValueData                        AS Summ
           --MovementId-Акция
           , MIFloat_PromoMovement.ValueData               AS MovementId_Promo
           --Протокол Дата/время начало
           , MIDate_StartBegin.ValueData                   AS StartBegin_mi
           --Протокол Дата/время завершение
           , MIDate_EndBegin.ValueData                     AS EndBegin_mi

           -- Количество Вес
           , MovementItem.Amount 
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END :: TFloat AS Amount_Weight
           -- Количество Шт.
           , MovementItem.Amount 
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END :: TFloat AS Amount_sh
                                    
       FROM Movement
            --Вид статуса
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            --Дата отгрузки контрагенту
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            --Дата маркировки
            LEFT JOIN MovementDate AS MovementDate_OperDateMark
                                   ON MovementDate_OperDateMark.MovementId =  Movement.Id
                                  AND MovementDate_OperDateMark.DescId = zc_MovementDate_OperDateMark()
            --М Дата/время создания документа
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            --М Дата/время создания на моб устр.
            LEFT JOIN MovementDate AS MovementDate_InsertMobile
                                   ON MovementDate_InsertMobile.MovementId = Movement.Id
                                  AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()
            --Протокол Дата/время начало
            LEFT JOIN MovementDate AS MovementDate_StartBegin
                                   ON MovementDate_StartBegin.MovementId = Movement.Id
                                  AND MovementDate_StartBegin.DescId = zc_MovementDate_StartBegin()
            --Дата прогноз (конечн.)
            LEFT JOIN MovementDate AS MovementDate_EndBegin
                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()
            --Дата/время отгрузки
            LEFT JOIN MovementDate AS MovementDate_CarInfo
                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()
            --Итого количество
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            --Номер заявки у контрагента
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            --Комментарий
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            --Примечание к отгрузке
            LEFT JOIN MovementString AS MovementString_CarComment
                                     ON MovementString_CarComment.MovementId = Movement.Id
                                    AND MovementString_CarComment.DescId = zc_MovementString_CarComment()
            --Подразделения (другой филиал) / Контрагент
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount  ON ObjectFloat_PrepareDayCount.ObjectId = MovementLinkObject_From.ObjectId AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
            LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount ON ObjectFloat_DocumentDayCount.ObjectId = MovementLinkObject_From.ObjectId AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()
            --Подразделение (другой филиал) / Подразделение
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            --Физические лица(экспедитор)
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId
            --Маршрут
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId
            --Сортировки маршрутов
            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId
            --Виды форм оплаты 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
            --Договор
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            --Прайс-лист
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId
            --Торговая сеть
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                         ON MovementLinkObject_Retail.MovementId = Movement.Id
                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId
            --Цена с НДС (да/нет)
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            --был ли распечатан документ (да/нет)
            LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                      ON MovementBoolean_Print.MovementId = Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()
            --печатать Примечание в Расходной накладной
            LEFT JOIN MovementBoolean AS MovementBoolean_PrintComment
                                      ON MovementBoolean_PrintComment.MovementId = Movement.Id
                                     AND MovementBoolean_PrintComment.DescId = zc_MovementBoolean_PrintComment()
            -- Есть ли товары с акцией в документе
            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId = Movement.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()
            --Был сформирован резерв
            LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                      ON MovementBoolean_Remains.MovementId = Movement.Id
                                     AND MovementBoolean_Remains.DescId = zc_MovementBoolean_Remains()
            --% НДС
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            --(-)% Скидки (+)% Наценки
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            --Итого количество, шт
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            --Итого количество, кг
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            --Итого количество дозаказ
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSecond
                                    ON MovementFloat_TotalCountSecond.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSecond.DescId = zc_MovementFloat_TotalCountSecond()
            --Итого сумма по накладной (без НДС)
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            --Итого сумма по накладной (с НДС)
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            --Итого сумма по накладной (с учетом НДС и скидки)
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            --Документ EDI
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            --Контрагент
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
            --Информация по отгрузке
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarInfo
                                         ON MovementLinkObject_CarInfo.MovementId = Movement.Id
                                        AND MovementLinkObject_CarInfo.DescId = zc_MovementLinkObject_CarInfo()
            LEFT JOIN Object AS Object_CarInfo ON Object_CarInfo.Id = MovementLinkObject_CarInfo.ObjectId
            --М Пользователи
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId
            --Виды статусов wms
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Status_wms
                                         ON MovementLinkObject_Status_wms.MovementId = Movement.Id
                                        AND MovementLinkObject_Status_wms.DescId = zc_MovementLinkObject_Status_wms()
            LEFT JOIN Object AS Object_Status_wms ON Object_Status_wms.Id = MovementLinkObject_Status_wms.ObjectId
            --М Глобальный уникальный идентификатор
            LEFT JOIN MovementString AS MovementString_GUID
                                     ON MovementString_GUID.MovementId = Movement.Id
                                    AND MovementString_GUID.DescId = zc_MovementString_GUID()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

            --документ Акция
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Promo
                                           ON MovementLinkMovement_Promo.MovementId = Movement.Id
                                          AND MovementLinkMovement_Promo.DescId = zc_MovementLinkMovement_Promo()
            LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = MovementLinkMovement_Promo.MovementChildId
            LEFT JOIN MovementDate AS MD_StartSale
                                   ON MD_StartSale.MovementId =  Movement_Promo.Id
                                  AND MD_StartSale.DescId = zc_MovementDate_StartSale()
            LEFT JOIN MovementDate AS MD_EndSale
                                   ON MD_EndSale.MovementId =  Movement_Promo.Id
                                  AND MD_EndSale.DescId = zc_MovementDate_EndSale()

            --строки документов
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  --AND MovementItem.isErased   = tmpIsErased.isErased
            -- Товар
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            --Вид товаров
            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
            --Цена
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            --Цена из Эксайта
            LEFT JOIN MovementItemFloat AS MIFloat_PriceEDI
                                        ON MIFloat_PriceEDI.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceEDI.DescId = zc_MIFloat_PriceEDI()
            --Цена за количество
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            --Количество дозаказ
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
            --Сумма с ндс и скидкой
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
            --MovementId-Акция
            LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                        ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                       AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
            --(-)% Скидки (+)% Наценки
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
            --Протокол Дата/время начало
            LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                       ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_StartBegin.DescId         = zc_MIDate_StartBegin()
            --Протокол Дата/время завершение
            LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                       ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_EndBegin.DescId         = zc_MIDate_EndBegin()

            -- Ед.изм. Товара
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- Вес Товара
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

        WHERE Movement.DescId = zc_Movement_OrderExternal()
          AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE

        ;

ALTER TABLE _bi_Doc_OrderExternal_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.25         *
*/

-- тест
--SELECT _bi_Doc_OrderExternal_View.Id,_bi_Doc_OrderExternal_View.GoodsId  FROM _bi_Doc_OrderExternal_View 
-- WHERE OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE
