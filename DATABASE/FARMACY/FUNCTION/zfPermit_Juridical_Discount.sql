-- Function: zfPermit_Juridical_Discount

DROP FUNCTION IF EXISTS zfPermit_Juridical_Discount (Integer, Integer);

CREATE OR REPLACE FUNCTION zfPermit_Juridical_Discount (
  IN inDiscountExternal integer,
  IN inJuridicalId integer
)
RETURNS integer AS
$BODY$
BEGIN

  IF EXISTS(SELECT ObjectFloat_SupplierID.ValueData::Integer   AS SupplierID
            FROM Object AS Object_DiscountExternalSupplier
                 LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                      ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalSupplier.Id
                                     AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalSupplier_DiscountExternal()

                 LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                      ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalSupplier.Id
                                     AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalSupplier_Juridical()

                 LEFT JOIN ObjectFloat AS ObjectFloat_SupplierID
                                       ON ObjectFloat_SupplierID.ObjectId = Object_DiscountExternalSupplier.Id 
                                      AND ObjectFloat_SupplierID.DescId = zc_ObjectFloat_DiscountExternalSupplier_SupplierID()

            WHERE Object_DiscountExternalSupplier.DescId = zc_Object_DiscountExternalSupplier()
              AND ObjectLink_DiscountExternal.ChildObjectId = inDiscountExternal
              AND ObjectLink_Juridical.ChildObjectId = inJuridicalID
              AND Object_DiscountExternalSupplier.isErased = False)
  THEN
    RETURN (SELECT ObjectFloat_SupplierID.ValueData::Integer   AS SupplierID
            FROM Object AS Object_DiscountExternalSupplier
                 LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                      ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalSupplier.Id
                                     AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalSupplier_DiscountExternal()

                 LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                      ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalSupplier.Id
                                     AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalSupplier_Juridical()

                 LEFT JOIN ObjectFloat AS ObjectFloat_SupplierID
                                       ON ObjectFloat_SupplierID.ObjectId = Object_DiscountExternalSupplier.Id 
                                      AND ObjectFloat_SupplierID.DescId = zc_ObjectFloat_DiscountExternalSupplier_SupplierID()

            WHERE Object_DiscountExternalSupplier.DescId = zc_Object_DiscountExternalSupplier()
              AND ObjectLink_DiscountExternal.ChildObjectId = inDiscountExternal
              AND ObjectLink_Juridical.ChildObjectId = inJuridicalID
            LIMIT 1); 
  ELSE
    RETURN 0;
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfPermit_Juridical_Discount (Integer, Integer) OWNER TO postgres;

/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   ÿ‡·ÎËÈ Œ.¬.
 12.05.22                                                       * 
*/

-- ÚÂÒÚ
SELECT * from zfPermit_Juridical_Discount (inDiscountExternal := 4521216 , inJuridicalId := 59611)