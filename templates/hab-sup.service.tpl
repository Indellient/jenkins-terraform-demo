[Unit]
Description=Habitat Supervisor

[Service]
ExecStart=/bin/hab sup run ${habopts}
Restart=on-failure

[Install]
WantedBy=default.target
