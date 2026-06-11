-- World Cup Draft Pool Schema

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Players table
CREATE TABLE IF NOT EXISTS public.players (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  draft_order INTEGER,
  total_points INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Teams table
CREATE TABLE IF NOT EXISTS public.teams (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  flag TEXT,
  fifa_code TEXT,
  iso_code TEXT,
  aliases TEXT[],
  status TEXT DEFAULT 'available', -- 'available', 'drafted'
  drafted_by UUID REFERENCES public.players(id),
  draft_pick_number INTEGER,
  group_wins INTEGER DEFAULT 0,
  group_draws INTEGER DEFAULT 0,
  advancement_stage TEXT DEFAULT 'eliminated', -- 'group', 'round-of-32', 'round-of-16', 'quarterfinal', 'semifinal', 'final', 'champion'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Draft picks table
CREATE TABLE IF NOT EXISTS public.draft_picks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pick_number INTEGER NOT NULL,
  round_number INTEGER NOT NULL,
  player_id UUID NOT NULL REFERENCES public.players(id),
  team_id UUID NOT NULL REFERENCES public.teams(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(pick_number)
);

-- Matches table (for future match tracking)
CREATE TABLE IF NOT EXISTS public.matches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  stage TEXT,
  group_name TEXT,
  team1_id UUID REFERENCES public.teams(id),
  team2_id UUID REFERENCES public.teams(id),
  team1_score INTEGER,
  team2_score INTEGER,
  status TEXT DEFAULT 'scheduled', -- 'scheduled', 'live', 'completed'
  match_date TIMESTAMP WITH TIME ZONE,
  venue TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Settings table
CREATE TABLE IF NOT EXISTS public.settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  buy_in NUMERIC DEFAULT 25,
  draft_locked BOOLEAN DEFAULT FALSE,
  draft_started BOOLEAN DEFAULT FALSE,
  draft_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Audit log table
CREATE TABLE IF NOT EXISTS public.audit_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  action TEXT NOT NULL,
  details JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_teams_status ON public.teams(status);
CREATE INDEX IF NOT EXISTS idx_teams_drafted_by ON public.teams(drafted_by);
CREATE INDEX IF NOT EXISTS idx_draft_picks_player_id ON public.draft_picks(player_id);
CREATE INDEX IF NOT EXISTS idx_draft_picks_team_id ON public.draft_picks(team_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_created_at ON public.audit_log(created_at DESC);

-- Enable Row Level Security
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.draft_picks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

-- Public read policies
CREATE POLICY "Enable public read access" ON public.players FOR SELECT USING (TRUE);
CREATE POLICY "Enable public read access" ON public.teams FOR SELECT USING (TRUE);
CREATE POLICY "Enable public read access" ON public.draft_picks FOR SELECT USING (TRUE);
CREATE POLICY "Enable public read access" ON public.matches FOR SELECT USING (TRUE);
CREATE POLICY "Enable public read access" ON public.settings FOR SELECT USING (TRUE);
CREATE POLICY "Enable public read access" ON public.audit_log FOR SELECT USING (TRUE);

-- Only service role can write (enforce via server-side code)
CREATE POLICY "Enable insert for authenticated users" ON public.players FOR INSERT WITH CHECK (FALSE);
CREATE POLICY "Enable update for authenticated users" ON public.players FOR UPDATE USING (FALSE);
CREATE POLICY "Enable delete for authenticated users" ON public.players FOR DELETE USING (FALSE);

CREATE POLICY "Enable insert for authenticated users" ON public.teams FOR INSERT WITH CHECK (FALSE);
CREATE POLICY "Enable update for authenticated users" ON public.teams FOR UPDATE USING (FALSE);
CREATE POLICY "Enable delete for authenticated users" ON public.teams FOR DELETE USING (FALSE);

CREATE POLICY "Enable insert for authenticated users" ON public.draft_picks FOR INSERT WITH CHECK (FALSE);
CREATE POLICY "Enable update for authenticated users" ON public.draft_picks FOR UPDATE USING (FALSE);
CREATE POLICY "Enable delete for authenticated users" ON public.draft_picks FOR DELETE USING (FALSE);

CREATE POLICY "Enable insert for authenticated users" ON public.matches FOR INSERT WITH CHECK (FALSE);
CREATE POLICY "Enable update for authenticated users" ON public.matches FOR UPDATE USING (FALSE);
CREATE POLICY "Enable delete for authenticated users" ON public.matches FOR DELETE USING (FALSE);

CREATE POLICY "Enable insert for authenticated users" ON public.settings FOR INSERT WITH CHECK (FALSE);
CREATE POLICY "Enable update for authenticated users" ON public.settings FOR UPDATE USING (FALSE);
CREATE POLICY "Enable delete for authenticated users" ON public.settings FOR DELETE USING (FALSE);

CREATE POLICY "Enable insert for authenticated users" ON public.audit_log FOR INSERT WITH CHECK (FALSE);
CREATE POLICY "Enable update for authenticated users" ON public.audit_log FOR UPDATE USING (FALSE);
CREATE POLICY "Enable delete for authenticated users" ON public.audit_log FOR DELETE USING (FALSE);
