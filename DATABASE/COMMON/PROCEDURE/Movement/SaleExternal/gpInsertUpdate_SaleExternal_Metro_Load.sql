-- Function: gpInsertUpdate_SaleExternal_Metro_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_SaleExternal_Metro_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_SaleExternal_Metro_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_SaleExternal_Metro_Load(
    IN inOperDate              TDateTime , --
    IN inRetailId              Integer   , --
    IN inPartnerExternalCode   TVarChar  , --
    IN inPartnerExternalName   TVarChar  , --
    IN inArticle               TVarChar  , --
    IN inGoodsName             TVarChar  , --
    IN inAmount                TVarChar    , -- ����������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbPartnerExternalId Integer;
   DECLARE vbGoodsPropertyId   Integer;
   DECLARE vbGoodsPropertyId_f Integer;
   DECLARE vbGoodsPropertyValueId Integer;
   DECLARE vbGoodsId           Integer;
   DECLARE vbGoodsKindId       Integer;
   DECLARE vbMovementId        Integer;
   DECLARE vbId                Integer;
   DECLARE vbAmount            TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SaleExternal());

     -- �������� ������ ����������
     IF COALESCE (inPartnerExternalName,'') = ''
     THEN
         RETURN;
     END IF;

     --��������������� inAmount � �����
     vbAmount := zfConvert_StringToFloat( REPLACE (REPLACE (inAmount, ' ','') , ',', '.')) ::TFloat;

     -- ��������
     IF COALESCE (vbAmount,0) = 0
     THEN
         -- ��������
         IF vbUserId = 5 AND 1=0
         THEN
             RAISE EXCEPTION '������.�� ����������� ���-��.';
         END IF;
         --
         RETURN;
     END IF;

     -- ��������
     IF COALESCE (inRetailId,0) = 0
     THEN
         RAISE EXCEPTION '������.�������� ���� �� �������';
     END IF;

     --���� PartnerExternal
     IF COALESCE (inPartnerExternalCode,'') <> ''
     THEN
         vbPartnerExternalId := (SELECT Object_PartnerExternal.Id
                                 FROM Object AS Object_PartnerExternal
                                      INNER JOIN ObjectString AS ObjectString_ObjectCode
                                                              ON ObjectString_ObjectCode.ObjectId = Object_PartnerExternal.Id
                                                             AND ObjectString_ObjectCode.DescId = zc_ObjectString_PartnerExternal_ObjectCode()
                                                             AND ObjectString_ObjectCode.ValueData = inPartnerExternalCode
                                      LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                           ON ObjectLink_Retail.ObjectId = Object_PartnerExternal.Id
                                                          AND ObjectLink_Retail.DescId = zc_ObjectLink_PartnerExternal_Retail()
                                 WHERE Object_PartnerExternal.DescId = zc_Object_PartnerExternal()
                                   AND (ObjectLink_Retail.ChildObjectId = inRetailId OR COALESCE(ObjectLink_Retail.ChildObjectId,0) = 0)
                                 );
     ELSE
     -- ����� ���� �� ������������
         vbPartnerExternalId := (SELECT Object_PartnerExternal.Id
                                 FROM Object AS Object_PartnerExternal
                                      LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                           ON ObjectLink_Retail.ObjectId = Object_PartnerExternal.Id
                                                          AND ObjectLink_Retail.DescId = zc_ObjectLink_PartnerExternal_Retail()
                                 WHERE Object_PartnerExternal.DescId = zc_Object_PartnerExternal()
                                   AND TRIM (COALESCE (Object_PartnerExternal.ValueData, '')) = TRIM (inPartnerExternalName)
                                   AND (ObjectLink_Retail.ChildObjectId = inRetailId OR COALESCE(ObjectLink_Retail.ChildObjectId,0) = 0)
                                 LIMIT 1
                                );
     END IF;

     --���� �� ������
     IF COALESCE (vbPartnerExternalId,0) = 0
     THEN
         --RAISE EXCEPTION '������.���������� ������� - <%> �� ������.', inPartnerExternalName;
         vbPartnerExternalId :=  lpInsertUpdate_Object_PartnerExternal (ioId         := 0                                                 :: Integer
                                                                      , inCode       := lfGet_ObjectCode(0, zc_Object_PartnerExternal())  :: Integer
                                                                      , inName       := TRIM (inPartnerExternalName)                      :: TVarChar
                                                                      , inObjectCode := inPartnerExternalCode                             :: TVarChar
                                                                      , inPartnerId  := 0                                                 :: Integer
                                                                      , inContractId := 0                                                 :: Integer
                                                                      , inRetailId   := inRetailId                                        :: Integer
                                                                      , inUserId     := vbUserId                                          :: Integer
                                                                      );
     ELSE
         --���� ������� ������ ������������ ������ �������� ����. ����
         PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Retail(), vbPartnerExternalId, inRetailId);
     END IF;

     IF COALESCE ((SELECT ObjectLink_Partner.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Partner
                   WHERE ObjectLink_Partner.ObjectId = vbPartnerExternalId
                     AND ObjectLink_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner())
                , 0) <> 0
     THEN
         --������� ������������� ������� �������, �� ����� � partner , ����� juridical, ����� GoodsProperty
         vbGoodsPropertyId_f := (SELECT ObjectLink_Juridical_GoodsProperty.ChildObjectId
                                 FROM ObjectLink AS ObjectLink_Partner
                                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner.ChildObjectId
                                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                           ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                          AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                 WHERE ObjectLink_Partner.ObjectId = vbPartnerExternalId
                                   AND ObjectLink_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
                                 );
     END IF;

     vbGoodsId := 0;
     vbGoodsKindId := 0;
     vbGoodsPropertyValueId := 0;

/*
if inArticle ILIKE '188191'
then
         RAISE EXCEPTION '������.(<%>)'
, (
SELECT count(*)
-- SELECT MAX (ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId) OVER (PARTITION BY ObjectLink_GoodsPropertyValue_Goods.ChildObjectId ,ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId) AS GoodsPropertyId_max
             FROM
                  (SELECT vbGoodsPropertyId_f AS GoodsPropertyId
                   WHERE COALESCE (vbGoodsPropertyId_f,0) <> 0
                  ) AS tmp
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                           ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmp.GoodsPropertyId
                                          AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                     INNER JOIN ObjectString AS ObjectString_Article
                                             ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_ArticleExternal()
                                            AND TRIM(ObjectString_Article.ValueData) = TRIM (inArticle)  --'26841'
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                          ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                         AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
           
)
;
end if;*/

     -- ������� GoodsId �� ��������
     SELECT tmp.GoodsId
          , tmp.GoodsKindId
          , tmp.GoodsPropertyValueId
          , tmp.GoodsPropertyId
            INTO vbGoodsId, vbGoodsKindId, vbGoodsPropertyValueId, vbGoodsPropertyId
     FROM
          (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId     AS GoodsId
                , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId AS GoodsKindId
                , ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId  AS GoodsPropertyValueId
                , ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId  AS GoodsPropertyId
                  -- ���� ����� �� 1 ������������� , ����� ������������
                , MAX (ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId) OVER (PARTITION BY ObjectLink_GoodsPropertyValue_Goods.ChildObjectId ,ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId) AS GoodsPropertyId_max
             FROM
                  (SELECT vbGoodsPropertyId_f AS GoodsPropertyId
                   WHERE COALESCE (vbGoodsPropertyId_f,0) <> 0
                  UNION
                   SELECT DISTINCT COALESCE (ObjectLink_Partner_GoodsProperty.ChildObjectId
                                 , COALESCE (ObjectLink_Contract_GoodsProperty.ChildObjectId
                                 , COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId
                                 , COALESCE (ObjectLink_Retail_GoodsProperty.ChildObjectId)))) AS GoodsPropertyId
                   FROM
                       (SELECT ObjectLink_Juridical_Retail.ObjectId AS JuridicalId
                             , ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                             , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                 AND ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                  ON ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                 AND ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                        WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                        AND ObjectLink_Juridical_Retail.ChildObjectId = inRetailId --310854
                        ) AS tmp
                        LEFT JOIN ObjectLink AS ObjectLink_Partner_GoodsProperty
                                             ON ObjectLink_Partner_GoodsProperty.ObjectId = tmp.PartnerId
                                            AND ObjectLink_Partner_GoodsProperty.DescId = zc_ObjectLink_Partner_GoodsProperty()
                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                             ON ObjectLink_Juridical_GoodsProperty.ObjectId = tmp.JuridicalId
                                            AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                        LEFT JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                                             ON ObjectLink_Contract_GoodsProperty.ObjectId = tmp.ContractId
                                            AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()
                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = tmp.JuridicalId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                        LEFT JOIN ObjectLink AS ObjectLink_Retail_GoodsProperty
                                             ON ObjectLink_Retail_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                            AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
                   WHERE COALESCE (vbGoodsPropertyId_f,0) = 0
                  ) AS tmp
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                           ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmp.GoodsPropertyId
                                          AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                     INNER JOIN ObjectString AS ObjectString_Article
                                             ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_ArticleExternal()
                                            AND TRIM(ObjectString_Article.ValueData) = TRIM (inArticle)  --'26841'
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                          ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                         AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
           ) AS tmp
     WHERE tmp.GoodsPropertyId = tmp.GoodsPropertyId_max;

     IF COALESCE (vbGoodsId,0) = 0
     THEN
         RAISE EXCEPTION '������. ����� <%> � ��������� <%> �� ������. ��� ���� <%> + <%> <%> � �� = <%> + <%>. (<%>)  (<%>) (<%>)'
                        , inGoodsName
                        , inArticle
                        , lfGet_Object_ValueData_sh (inRetailId)
                        , lfGet_Object_ValueData_sh (vbGoodsPropertyId_f)
                        , lfGet_Object_ValueData_sh (vbGoodsPropertyId)
                        , inPartnerExternalCode, inPartnerExternalName
                        , inRetailId
                        , vbGoodsPropertyId_f
                        , vbGoodsPropertyId
                         ;
     END IF;

     -- ��������� ��-��  zc_ObjectString_GoodsPropertyValue_NameExternal
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_NameExternal(), vbGoodsPropertyValueId, inGoodsName);


     -- ������� ����� ��������
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                        AND MovementLinkObject_From.ObjectId = vbPartnerExternalId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                                         ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                                        AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
                                                        AND MovementLinkObject_GoodsProperty.ObjectId = vbGoodsPropertyId
                      WHERE Movement.DescId = zc_Movement_SaleExternal()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                        AND Movement.OperDate =  DATE_TRUNC ('MONTH', inOperDate)
                      );

     -- ���� �� ����� �������
     IF COALESCE (vbMovementId,0) = 0
     THEN
         -- ��������� <��������>
         vbMovementId:= lpInsertUpdate_Movement_SaleExternal (ioId               := 0
                                                            , inInvNumber        := CAST (NEXTVAL ('movement_SaleExternal_seq') AS TVarChar)
                                                            , inOperDate         := inOperDate
                                                            , inFromId           := vbPartnerExternalId
                                                            , inGoodsPropertyId  := vbGoodsPropertyId
                                                            , inComment          := '��������' :: TVarChar
                                                            , inUserId           := vbUserId
                                                             )AS tmp;
     END IF;

     -- ����� ���� ����� ����� ��� �������
     vbId := (SELECT MovementItem.Id
              FROM MovementItem
                   INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                    AND MILinkObject_GoodsKind.ObjectId = vbGoodsKindId
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
                AND MovementItem.ObjectId = vbGoodsId
              LIMIT 1
             );

     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_SaleExternal (ioId           := COALESCE (vbId,0) ::Integer
                                                     , inMovementId   := vbMovementId      ::Integer
                                                     , inGoodsId      := vbGoodsId         ::Integer
                                                     , inAmount       := CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh()
                                                                              THEN vbAmount -- vbAmount / CASE WHEN ObjectFloat_Weight.ValueData > 0 THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                                                              ELSE vbAmount
                                                                         END               ::TFloat
                                                     , inGoodsKindId  := vbGoodsKindId     ::Integer
                                                     , inUserId       := vbUserId          ::Integer
                                                      )
     FROM ObjectLink AS ObjectLink_Measure
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = ObjectLink_Measure.ObjectId
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
     WHERE ObjectLink_Measure.ObjectId = vbGoodsId
       AND ObjectLink_Measure.DescId = zc_ObjectLink_Goods_Measure();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
01.11.20          *
*/

-- ����
--