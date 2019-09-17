select c.parsed.subject_dn, c.parsed.issuer_dn, c.raw, c.fingerprint_sha256
from `censys-io`.certificates_public.certificates c  join
(select * from (
SELECT fingerprint_sha256
    FROM (
        SELECT fingerprint_sha256, Rank()
          over (Partition BY parsed.issuer_dn ORDER by parsed.subject_dn) AS Rank
        FROM `censys-io`.certificates_public.certificates
        where validation.nss.valid = true
        limit 10000000
        ) rs WHERE Rank <= 5000) order by rand() limit 1000000) rs
      on rs.fingerprint_sha256 = c.fingerprint_sha256
