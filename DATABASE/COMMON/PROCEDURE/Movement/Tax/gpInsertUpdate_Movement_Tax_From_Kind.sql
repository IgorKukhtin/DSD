-- Function: gpInsertUpdate_Movement_Tax_From_Kind()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar, TVarChar, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (
    IN inMovementId                 Integer  , -- ключ Документа
    IN inDocumentTaxKindId          Integer  , -- Тип формирования налогового документа
   OUT outInvNumberPartner_Master   TVarChar , --
   OUT outDocumentTaxKindName       TVarChar , --
    IN inSession                    TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbTaxId            Integer;
   DECLARE vbUserId           Integer;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbInvNumber        TVarChar;
   DECLARE vbInvNumberPartner TVarChar;
   DECLARE vbPriceWithVAT     Boolean ;
   DECLARE vbVATPercent       TFloat;
   DECLARE vbFromId           Integer;
   DECLARE vbToId             Integer;
   DECLARE vbPartnerId        Integer;
   DECLARE vbContractId       Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax());
   
            IF COALESCE (inDocumentTaxKindId,0) =  zc_Enum_DocumentTaxKind_Tax()
               THEN
               /* выбираем реквизиты для обновления/создания шапки НН */
               SELECT MovementLinkMovement.MovementChildId 
                    , MovementSale.InvNumber
                    , MovementSale.InvNumberPartner_Master                     
                    , MovementSale.OperDate
                    , MovementSale.PriceWithVAT
                    , MovementSale.VATPercent
                    , ObjectLink_Contract_JuridicalBasis.ChildObjectId  -- от кого
                    , ObjectLink_Partner_Juridical.ChildObjectId          -- кому
                    , MovementSale.ToId           	             -- контрагент 
                    , MovementSale.ContractId 
                    
               INTO  vbTaxId, vbInvNumber, vbInvNumberPartner, vbOperDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId

               FROM gpGet_Movement_Sale(inMovementId, CURRENT_DATE , inSession) AS MovementSale
               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementSale.ToId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               
               LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                    ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementSale.ContractId
                                   AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
               
               LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = MovementSale.Id
                                             AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();



               SELECT tmp.ioInvNumberPartner
                    , Object_DocumentTaxKind.ValueData
                    , tmp.ioId                   
               INTO outInvNumberPartner_Master, outDocumentTaxKindName, vbTaxId
     
               FROM lpInsertUpdate_Movement_Tax(
                       ioId := COALESCE (vbTaxId,0)
                     , inInvNumber := vbInvNumber
                     , ioInvNumberPartner := vbInvNumberPartner                    
                     , inOperDate := vbOperDate
                     , inChecked := false
                     , inDocument := false
                     , inPriceWithVAT := vbPriceWithVAT
                     , inVATPercent := vbVATPercent
                     , inFromId := vbFromId                                  -- от кого
                     , inToId := vbToId                                      -- кому
                     , inPartnerId := vbPartnerId           	             -- контрагент 
                     , inContractId := vbContractId
                     , inDocumentTaxKindId := inDocumentTaxKindId
                     , inUserId := vbUserId ) as tmp

               LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = inDocumentTaxKindID;

               -- сохранили Продажи с Нологовой
               PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), inMovementId, vbTaxId);
           
               /*выбрать товары из продажы для обновления/создания НН*/
       /*WITH tmpGoodsSale AS (SELECT MovementItem.ObjectId AS GoodsId
                                  , MILinkObject_GoodsKind.ObjectId AS GoodsKindId 
                                  , MIFloat_CountForPrice.ValueData AS CountForPrice_Sale
                                  , MIFloat_Price.ValueData::TFloat AS Price_Sale
                                  , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) ::TFloat   AS Amount_Sale
                             FROM MovementItem 
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                               --AND MIFloat_Price.ValueData <> 0   -- спросить у Кости нужны ли нулевые цены
                                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()                             
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             WHERE MovementItem.MovementId = inMovementId--130344--  --130344 --  
                             GROUP BY MovementItem.ObjectId
                                    , MILinkObject_GoodsKind.ObjectId
                                    , MIFloat_Price.ValueData 
                                    , MIFloat_CountForPrice.ValueData 
                            )
             
,
    tmpGoodsTax AS (SELECT MovementItem.ObjectId AS GoodsId
                                 , MILinkObject_GoodsKind.ObjectId  AS GoodsKindId
                                 , MIFloat_Price.ValueData::TFloat  AS Price_Tax
                                 , MovementItem.Amount::TFloat      AS Amount_Tax
                                 , MovementItem.Id AS MovementItemId_Tax 
                            FROM Movement 
                                 JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.Amount<>0
                    
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                               --AND MIFloat_Price.ValueData <> 0
                                                
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 WHERE Movement.Id =  vbTaxId--173702 --  --
                                   AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())
                            )*/

               PERFORM lpInsertUpdate_MovementItem_Tax(
                       ioId := COALESCE ( tmpGoodsTax.MovementItemId_Tax,0)    
                     , inMovementId := vbTaxId       
                     , inGoodsId := tmpGoodsSale.GoodsId
                     , inAmount := tmpGoodsSale.Amount_Sale
                     , inPrice := tmpGoodsSale.Price_Sale
                     , ioCountForPrice := tmpGoodsSale.CountForPrice_Sale
                     , inGoodsKindId := tmpGoodsSale.GoodsKindId
                     , inUserId := vbUserId)        
               FROM (SELECT MovementItem.ObjectId AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                          , MIFloat_CountForPrice.ValueData AS CountForPrice_Sale
                          , MIFloat_Price.ValueData::TFloat AS Price_Sale
                          , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) ::TFloat   AS Amount_Sale
                     FROM MovementItem 
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                               --AND MIFloat_Price.ValueData <> 0   -- спросить у Кости нужны ли нулевые цены
                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()                             
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     WHERE MovementItem.MovementId = inMovementId--130344--  --130344 --  
                       AND MovementItem.isErased = false 
                     GROUP BY MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                            , MIFloat_Price.ValueData 
                            , MIFloat_CountForPrice.ValueData 
                      ) as tmpGoodsSale
                      LEFT JOIN (SELECT MovementItem.ObjectId AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                                      , MIFloat_Price.ValueData::TFloat  AS Price_Tax
                                      , MovementItem.Amount::TFloat      AS Amount_Tax
                                      , MovementItem.Id AS MovementItemId_Tax 
                                 FROM Movement 
                                      JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.Amount<>0
                                                       AND MovementItem.isErased = false 
                                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                               --AND MIFloat_Price.ValueData <> 0
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 WHERE Movement.Id =  vbTaxId--173702 --  --
                                   AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())
                                 ) AS tmpGoodsTax ON tmpGoodsTax.GoodsId = tmpGoodsSale.GoodsId
                                                 AND tmpGoodsTax.GoodsKindId = tmpGoodsSale.GoodsKindId
                                                 AND tmpGoodsTax.Price_Tax = tmpGoodsSale.Price_Sale;

              --удаляем лишние строки из Налоговой                                   
               PERFORM gpMovementItem_Tax_SetErased(
                       inMovementItemId := tmpGoodsTax.MovementItemId_Tax
                     , inSession := inSession)
               FROM (SELECT MovementItem.ObjectId AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                          , MIFloat_Price.ValueData::TFloat  AS Price_Tax
                          , MovementItem.Amount::TFloat      AS Amount_Tax
                          , MovementItem.Id AS MovementItemId_Tax 
                     FROM MovementItem
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                              --AND MIFloat_Price.ValueData <> 0
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     WHERE MovementItem.MovementId =  vbTaxId--173702 --  --
                       AND MovementItem.Amount<>0
                       AND MovementItem.isErased = false 
                     ) AS tmpGoodsTax 
                     LEFT JOIN (SELECT MovementItem.ObjectId AS GoodsId
                                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                                     , MIFloat_CountForPrice.ValueData AS CountForPrice_Sale
                                     , MIFloat_Price.ValueData::TFloat AS Price_Sale
                                     , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) ::TFloat   AS Amount_Sale
                                FROM MovementItem 
                                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                               --AND MIFloat_Price.ValueData <> 0   -- спросить у Кости нужны ли нулевые цены
                                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                 ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()                             
                                     LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                WHERE MovementItem.MovementId = inMovementId       --130344--  --130344 --  
                                  AND MovementItem.isErased = false       
                                GROUP BY MovementItem.ObjectId
                                       , MILinkObject_GoodsKind.ObjectId
                                       , MIFloat_Price.ValueData 
                                       , MIFloat_CountForPrice.ValueData 
                            ) as tmpGoodsSale ON tmpGoodsSale.GoodsId = tmpGoodsTax.GoodsId
                                             AND tmpGoodsSale.GoodsKindId = tmpGoodsTax.GoodsKindId
                                             AND tmpGoodsSale.Price_Sale = tmpGoodsTax.Price_Tax 
               WHERE tmpGoodsSale.GoodsId IS NULL ;

            ELSE 
                           
                  SELECT '12345/789'
                       , Object_DocumentTaxKind.ValueData
                  INTO outInvNumberPartner_Master, outDocumentTaxKindName

                  FROM Object AS Object_DocumentTaxKind
                  WHERE Object_DocumentTaxKind.Id = inDocumentTaxKindId;

      
            END IF;   
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.03.14         *
 23.03.14                                        * all
 13.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- все
-- SELECT gpInsertUpdate_Movement_Tax_From_Kind FROM gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- все


      
--select * from gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 16759 , inDocumentTaxKindId := zc_Enum_DocumentTaxKind_Tax() ,  inSession := '5');
         
/*select * from Movement
join  where id = 176021
*/
/*select * from Movement
LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = Movement.Id
                              AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
 where  InvNumber = '140574'
and Movement.descid = zc_Movement_Sale()*/