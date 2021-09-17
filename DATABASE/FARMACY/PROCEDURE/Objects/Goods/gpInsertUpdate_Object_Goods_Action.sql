-- Function: gpInsertUpdate_Object_Goods_Action()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_Action(TVarChar, Integer, TFloat, TFloat, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_Action(
    IN inGoodsCode           TVarChar  ,    -- ��� ������� <�����>
    IN inObjectId            Integer   ,    -- ���� ������� <���������>
    IN inMinimumLot          TFloat    ,    -- ����������� ����������
    IN inPromoBonus          TFloat    ,    -- ����� �� �����
    IN inPromoBonusName      TVarChar  ,    -- ������������ �������� �������� �� �����
    IN inAreaId              Integer   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE text_var1 text;
   DECLARE vbMinimumLot TFloat;
   DECLARE vbIsPromo boolean;
BEGIN
    --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
    vbUserId := inSession;

    IF COALESCE(inObjectId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� ����������';
    END IF;
    IF COALESCE(inMinimumLot,0) < 0
    THEN
        RAISE EXCEPTION '������.����������� ���������� <%> �� ����� ���� ������ ����.', inMCSValue;
    END IF;
    
    
    IF COALESCE (inAreaId, 0) = 0 
    THEN
        inAreaId := zc_Area_Basis();      --�����
    END IF;
    
    IF inMinimumLot = 0 
    THEN 
        inMinimumLot := NULL;
    END IF;
    
    -- ���� �� ���� � inObjectId  � ������    
    SELECT Object_Goods_View.Id, Object_Goods_View.MinimumLot, Object_Goods_View.IsPromo
    INTO vbGoodsId, vbMinimumLot, vbIsPromo
    FROM Object_Goods_View 
    WHERE Object_Goods_View.ObjectId = inObjectId
      AND Object_Goods_View.GoodsCode = inGoodsCode
      AND COALESCE (Object_Goods_View.AreaId, zc_Area_Basis()) = inAreaId;      -- zc_ObjectLink_Goods_Area = NULL, ��� ������ ��� ������ = ����� = zc_Area_Basis() �.�. update ��� ������ ����

    IF COALESCE(vbGoodsId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Goods_MinimumLot(), vbGoodsId, inMinimumLot);    
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Goods_PromoBonus(), vbGoodsId, inPromoBonus);    

        PERFORM lpInsertUpdate_objectString(zc_ObjectString_Goods_PromoBonusName(), vbGoodsId, inPromoBonusName);    

        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Promo(), vbGoodsId, True);

        IF COALESCE(inMinimumLot,0) <> vbMinimumLot 
        THEN
           -- ��������� �������� <���� �������������>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_UpdateMinimumLot(), vbGoodsId, CURRENT_TIMESTAMP);
          -- ��������� �������� <������������ (�������������)>
          PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UpdateMinimumLot(), vbGoodsId, vbUserId);
        END IF;
   
        IF vbIsPromo <> TRUE 
        THEN
           -- ��������� �������� <���� �������������>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_UpdateMinimumLot(), vbGoodsId, CURRENT_TIMESTAMP);
          -- ��������� �������� <������������ (�������������)>
          PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UpdateMinimumLot(), vbGoodsId, vbUserId);
        END IF;

          -- ��������� � ������� �������
        BEGIN
          UPDATE Object_Goods_Juridical SET isPromo          = True
                                          , MinimumLot       = NULLIF(inMinimumLot, 0)
                                          , PromoBonus       = NULLIF(inPromoBonus, 0)
                                          , PromoBonusName   = NULLIF(inPromoBonusName, '')
                                          , UserUpdateId     = vbUserId
                                          , DateUpdate       = CURRENT_TIMESTAMP
                                          , UserUpdateMinimumLotId = CASE WHEN COALESCE(inMinimumLot,0) <> vbMinimumLot THEN vbUserId ELSE UserUpdateMinimumLotId END
                                          , DateUpdateMinimumLot   = CASE WHEN COALESCE(inMinimumLot,0) <> vbMinimumLot THEN CURRENT_TIMESTAMP ELSE DateUpdateMinimumLot END
                                          , UserUpdateisPromoId = CASE WHEN vbIsPromo <> TRUE THEN vbUserId ELSE UserUpdateisPromoId END
                                          , DateUpdateisPromo   = CASE WHEN vbIsPromo <> TRUE THEN CURRENT_TIMESTAMP ELSE DateUpdateisPromo END
          WHERE Object_Goods_Juridical.Id = vbGoodsId
            AND (COALESCE(Object_Goods_Juridical.MinimumLot, 0) <> COALESCE(inMinimumLot, 0)
             OR Object_Goods_Juridical.isPromo <> True)
            ;  
        EXCEPTION
           WHEN others THEN 
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
             PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_Object_Goods_Action', text_var1::TVarChar, vbUserId);
        END;

        -- ��������� ��������
        PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId);

    END IF;

    -- !!!�������� ��� �����!!!
/*    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> ', inSession;
    END IF;
*/        
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 10.08.21                                                                      * 

*/                                          

/* SELECT * FROM gpInsertUpdate_Object_Goods_Action(inGoodsCode := '5361002'
                                                , inObjectId := 59610 
                                                , inMinimumLot := 10
                                                , inAreaId := zc_Area_Basis()
                                                , inSession := zfCalc_UserAdmin());
)*/

                                           