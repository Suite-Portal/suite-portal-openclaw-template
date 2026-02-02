#!/usr/bin/env node

/**
 * Sync files from Supabase Storage to agent workspace
 * Run on container startup to pull agent's files
 */

const fs = require('fs').promises;
const path = require('path');

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_KEY;
const SUPABASE_BUCKET = process.env.SUPABASE_BUCKET || 'Sentinel';
const AGENT_ID = process.env.AGENT_ID;

async function syncFiles() {
  if (!SUPABASE_URL || !SUPABASE_KEY || !AGENT_ID) {
    console.log('⚠️  Supabase config not set - skipping file sync');
    return;
  }

  try {
    console.log(`📦 Syncing files for agent ${AGENT_ID}...`);

    // List files from Supabase Storage
    const listUrl = `${SUPABASE_URL}/storage/v1/object/list/${SUPABASE_BUCKET}?prefix=agents/${AGENT_ID}/`;
    const listResponse = await fetch(listUrl, {
      headers: {
        'Authorization': `Bearer ${SUPABASE_KEY}`,
        'apikey': SUPABASE_KEY,
      },
    });

    if (!listResponse.ok) {
      console.log('⚠️  No files found or access denied');
      return;
    }

    const files = await listResponse.json();

    if (!files || files.length === 0) {
      console.log('✅ No files to sync');
      return;
    }

    console.log(`📥 Downloading ${files.length} files...`);

    // Create files directory in workspace
    await fs.mkdir('/workspace/files', { recursive: true });

    // Download each file
    for (const file of files) {
      const filePath = `${SUPABASE_BUCKET}/${file.name}`;
      const downloadUrl = `${SUPABASE_URL}/storage/v1/object/${filePath}`;
      
      const response = await fetch(downloadUrl, {
        headers: {
          'Authorization': `Bearer ${SUPABASE_KEY}`,
          'apikey': SUPABASE_KEY,
        },
      });

      if (response.ok) {
        const buffer = await response.arrayBuffer();
        const filename = path.basename(file.name);
        await fs.writeFile(`/workspace/files/${filename}`, Buffer.from(buffer));
        console.log(`  ✓ ${filename}`);
      }
    }

    console.log(`✅ Synced ${files.length} files to /workspace/files`);
  } catch (error) {
    console.error('❌ File sync failed:', error.message);
  }
}

syncFiles();
