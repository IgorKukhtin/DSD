DO $$ 
BEGIN

      IF (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('LoadGoodsBarCode'))) 
      THEN
           ALTER TABLE LoadGoodsBarCode ADD RetailId Integer;

           DROP INDEX IF EXISTS idx_LoadGoodsBarCode_Code;
           CREATE UNIQUE INDEX idx_LoadGoodsBarCode_Code ON LoadGoodsBarCode (RetailId, Code);
           
           UPDATE LoadGoodsBarCode 
           SET RetailId = ObjectLink_Goods_Object.ChildObjectId
           FROM ObjectLink AS ObjectLink_Goods_Object 
           WHERE ObjectLink_Goods_Object.ObjectId = GoodsId
             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object() 
             AND GoodsId <> 0;
      END IF;

END;
$$;