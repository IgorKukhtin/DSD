-- Function: gpInsertUpdate_Movement_OrderExternal_1C()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderExternal_1C (Integer, Integer, TVarChar, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderExternal_1C(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioMovementItemId      Integer   , -- Ключ объекта <Элемент документа>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер заявки у контрагента
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromCode_1C         Integer   , -- От кого, код 1С
    IN inGoodsCode_1C        Integer   , -- Товар, код 1С
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbPriceListId     Integer;
   DECLARE vbBranchId        Integer;
   DECLARE vbUnitId          Integer;
   DECLARE vbPartnerId       Integer;
   DECLARE vbContractId      Integer;
   DECLARE vbPaidKindId      Integer;
   DECLARE vbChangePercent   TFloat;
   DECLARE vbRouteId         Integer;
   DECLARE vbRouteSortingId  Integer;
   DECLARE vbPersonalId      Integer;

   DECLARE vbGoodsId         Integer;
   DECLARE vbGoodsKindId     Integer;
   DECLARE vbPrice           TFloat;
   DECLARE vbCountForPrice   TFloat;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());


     -- !!!константа!!!
     vbUnitId:= 346093; -- Склад ГП ф.Одесса
     vbBranchId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = vbUnitId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch());


     -- !!!всегда!!! предварительный поиск документа для !!!не удаленных!!!
     ioId:= (SELECT Movement.Id
             FROM Movement
                  INNER JOIN MovementBoolean AS MovementBoolean_isLoad 
                                             ON MovementBoolean_isLoad.MovementId = Movement.Id
                                            AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                                            AND MovementBoolean_isLoad.ValueData = TRUE
                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                               AND MovementLinkObject_To.ObjectId = vbUnitId
             WHERE Movement.OperDate = inOperDate
               AND Movement.InvNumber = inInvNumber
               AND Movement.DescId = zc_Movement_OrderExternal()
               AND Movement.StatusId <> zc_Enum_Status_Erased()
            );

     -- !!!всегда!!! поиск <От кого>
     SELECT ObjectLink_Partner1CLink_Partner.ChildObjectId AS PartnerId
          , View_Contract.ContractId
          , View_Contract.PaidKindId
          , View_Contract.ChangePercent
          , ObjectLink_Partner_Route.ChildObjectId         AS RouteId
          , ObjectLink_Partner_RouteSorting.ChildObjectId  AS RouteSortingId
          , ObjectLink_Partner_MemberTake.ChildObjectId    AS PersonalId
            INTO vbPartnerId, vbContractId, vbPaidKindId, vbChangePercent, vbRouteId, vbRouteSortingId, vbPersonalId
     FROM Object AS Object_Partner1CLink
          INNER JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                               AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                               AND ObjectLink_Partner1CLink_Branch.ChildObjectId = zfGetBranchLinkFromBranchPaidKind (vbBranchId, zc_Enum_PaidKind_SecondForm())
          INNER JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                               ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                              AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()
          LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = ObjectLink_Partner1CLink_Contract.ChildObjectId
                                                         AND View_Contract.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                               ON ObjectLink_Partner_Route.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                              AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                               ON ObjectLink_Partner_RouteSorting.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                              AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                               ON ObjectLink_Partner_MemberTake.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                              AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
     WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
       AND Object_Partner1CLink.ObjectCode = inFromCode_1C;


     -- сохранили <Документ>
     SELECT tmp.ioId, tmp.outOperDatePartner, tmp.ioPriceListId
            INTO ioId, vbOperDatePartner, vbPriceListId
     FROM gpInsertUpdate_Movement_OrderExternal (ioId                  := ioId
                                               , inInvNumber           := inInvNumber
                                               , inInvNumberPartner    := inInvNumberPartner
                                               , inOperDate            := inOperDate
                                               , inOperDateMark        := (SELECT ValueData FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDateMark())
                                               , inChangePercent       := COALESCE ((SELECT ValueData FROM MovementFloat WHERE MovementId = ioId AND DescId = zc_MovementFloat_ChangePercent()), vbChangePercent)
                                               , inFromId              := COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_From()), vbPartnerId)
                                               , inToId                := vbUnitId
                                               , inPaidKindId          := COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_PaidKind()), vbPaidKindId)
                                               , inContractId          := COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_Contract()), vbContractId)
                                               , inRouteId             := COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_Route()), vbRouteId)
                                               , inRouteSortingId      := COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_RouteSorting()), vbRouteSortingId)
                                               , inPersonalId          := COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_Personal()), vbPersonalId)
                                               , ioPriceListId         := COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_PriceList()), 0)
                                               , inPartnerId           := COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_Partner()), 0)
                                               , inSession             := inSession
                                                ) AS tmp;

     -- сохранили свойство <1С>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), ioId, TRUE);



     -- !!!всегда!!! поиск <Товара>
     SELECT ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId
          , ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId
            INTO vbGoodsId, vbGoodsKindId
     FROM (SELECT Object_GoodsByGoodsKind1CLink.Id AS ObjectId
           FROM Object AS Object_GoodsByGoodsKind1CLink
                INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                     ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                    AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                                    AND ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId = zfGetBranchLinkFromBranchPaidKind (vbBranchId, zc_Enum_PaidKind_SecondForm())
           WHERE Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
             AND Object_GoodsByGoodsKind1CLink.ObjectCode = inGoodsCode_1C
           ) AS tmpGoods
           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = tmpGoods.ObjectId
                               AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()
           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = tmpGoods.ObjectId
                               AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind();


     -- !!!всегда!!! поиск <Цены>
     /*SELECT tmp.ValuePrice, 1
            INTO vbPrice, vbCountForPrice
     FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= inOperDate) AS tmp
     WHERE tmp.GoodsId = vbGoodsId;*/

     -- сохранили <Элемент документа>
     SELECT tmp.ioId INTO ioMovementItemId
     FROM gpInsertUpdate_MovementItem_OrderExternal (ioId                 := ioMovementItemId
                                                   , inMovementId         := ioId
                                                   , inGoodsId            := vbGoodsId
                                                   , inAmount             := inAmount
                                                   , inAmountSecond       := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioMovementItemId AND DescId = zc_MIFloat_AmountSecond()), 0)
                                                   , inGoodsKindId        := vbGoodsKindId
                                                   , ioPrice              := inPrice -- vbPrice
                                                   , ioCountForPrice      := 1       -- vbCountForPrice
                                                   , inSession            := inSession
                                                    ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.04.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_OrderExternal_1C (ioId:= 0, ioMovementItemId:=0, inInvNumber:= '1', inInvNumberPartner:= '1C', inOperDate:= '01.04.2015', inFromCode_1C:= 7020874, inGoodsCode_1C:= 4523, inAmount:= 1, inPrice:= 1, inSession:= zfCalc_UserAdmin()) -- С/к Балык "Дарницкий" в/с ДСТУбв
-- SELECT * FROM gpInsertUpdate_Movement_OrderExternal_1C (ioId:= 0, ioMovementItemId:=0, inInvNumber:= '1', inInvNumberPartner:= '1C', inOperDate:= '01.04.2015', inFromCode_1C:= 7020874, inGoodsCode_1C:= 24291, inAmount:= 1, inPrice:= 1, inSession:= zfCalc_UserAdmin()) -- Балик Касло н/к в/г Алан.
