-- ═══════════════════════════════════════════════════
-- Genius CRM - Supabase Schema Setup
-- Supabase Dashboard > SQL Editor'da çalıştırın
-- ═══════════════════════════════════════════════════

-- ── Companies ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS companies (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text NOT NULL,
  sector      text DEFAULT 'Diğer',
  employees   integer,
  website     text,
  phone       text,
  email       text,
  revenue     bigint,
  status      text DEFAULT 'Aktif' CHECK (status IN ('Aktif','Pasif','Potansiyel')),
  address     text,
  created_at  timestamptz DEFAULT now()
);

-- ── Contacts ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS contacts (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name  text NOT NULL,
  last_name   text NOT NULL,
  email       text,
  phone       text,
  company     text,
  title       text,
  status      text DEFAULT 'Potansiyel' CHECK (status IN ('Müşteri','Potansiyel','Kaybedildi')),
  source      text DEFAULT 'Web Sitesi',
  note        text,
  created_at  timestamptz DEFAULT now()
);

-- ── Deals ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS deals (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name         text NOT NULL,
  company      text,
  contact_name text,
  value        bigint DEFAULT 0,
  stage        text DEFAULT 'Nitelik' CHECK (stage IN ('Nitelik','İlk Görüşme','Teklif','Müzakere','Kazanıldı')),
  probability  integer DEFAULT 50 CHECK (probability BETWEEN 0 AND 100),
  close_date   date,
  priority     text DEFAULT 'Orta' CHECK (priority IN ('Düşük','Orta','Yüksek')),
  note         text,
  created_at   timestamptz DEFAULT now()
);

-- ── Activities ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS activities (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type        text NOT NULL,
  title       text NOT NULL,
  contact_name text,
  date        date,
  status      text DEFAULT 'Planlandı' CHECK (status IN ('Planlandı','Tamamlandı','İptal Edildi')),
  description text,
  created_at  timestamptz DEFAULT now()
);

-- ── Row Level Security (Public erişim) ─────────────
ALTER TABLE companies  ENABLE ROW LEVEL SECURITY;
ALTER TABLE contacts   ENABLE ROW LEVEL SECURITY;
ALTER TABLE deals      ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;

-- Tüm işlemlere izin ver (anon + authenticated)
CREATE POLICY "public_all" ON companies  FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_all" ON contacts   FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_all" ON deals      FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_all" ON activities FOR ALL USING (true) WITH CHECK (true);

-- ── Örnek Veriler ───────────────────────────────────
INSERT INTO companies (name, sector, employees, website, phone, email, revenue, status, address) VALUES
  ('Genius Teknoloji', 'Teknoloji', 120, 'geniusteknoloji.com', '+90 212 111 22 33', 'info@genius.com', 5000000, 'Aktif', 'İstanbul'),
  ('Alpha Finans', 'Finans', 300, 'alphafinans.com', '+90 212 444 55 66', 'info@alpha.com', 15000000, 'Aktif', 'Ankara'),
  ('Beta Sağlık', 'Sağlık', 85, 'betasaglik.com', '+90 232 777 88 99', 'info@beta.com', 3000000, 'Potansiyel', 'İzmir');

INSERT INTO contacts (first_name, last_name, email, phone, company, title, status, source) VALUES
  ('Ahmet', 'Yılmaz', 'ahmet@genius.com', '+90 532 111 22 33', 'Genius Teknoloji', 'CEO', 'Müşteri', 'Referans'),
  ('Fatma', 'Demir', 'fatma@alpha.com', '+90 542 444 55 66', 'Alpha Finans', 'CFO', 'Müşteri', 'Web Sitesi'),
  ('Mehmet', 'Kaya', 'mehmet@beta.com', '+90 552 777 88 99', 'Beta Sağlık', 'Müdür', 'Potansiyel', 'Etkinlik'),
  ('Ayşe', 'Şahin', 'ayse@ornek.com', '+90 562 123 45 67', 'Diğer', 'Uzman', 'Potansiyel', 'Sosyal Medya');

INSERT INTO deals (name, company, contact_name, value, stage, probability, close_date, priority) VALUES
  ('ERP Entegrasyonu', 'Genius Teknoloji', 'Ahmet Yılmaz', 150000, 'Teklif', 70, '2026-06-15', 'Yüksek'),
  ('Analitik Platform', 'Alpha Finans', 'Fatma Demir', 250000, 'Müzakere', 85, '2026-05-30', 'Yüksek'),
  ('Mobil Uygulama', 'Beta Sağlık', 'Mehmet Kaya', 80000, 'İlk Görüşme', 40, '2026-07-01', 'Orta'),
  ('Web Sitesi Yenileme', 'Genius Teknoloji', 'Ahmet Yılmaz', 45000, 'Kazanıldı', 100, '2026-04-20', 'Düşük');

INSERT INTO activities (type, title, contact_name, date, status, description) VALUES
  ('📞 Arama', 'Ürün demo araması', 'Ahmet Yılmaz', '2026-05-08', 'Tamamlandı', 'Demo başarılı geçti.'),
  ('🤝 Toplantı', 'Teklif sunumu', 'Fatma Demir', '2026-05-09', 'Planlandı', 'Alpha Finans ile toplantı.'),
  ('📧 E-posta', 'Sözleşme gönderildi', 'Mehmet Kaya', '2026-05-07', 'Tamamlandı', '');
