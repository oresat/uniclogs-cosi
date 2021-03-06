---
meta:
  id: oresat0
  title: OreSat-0 Decoder Struct
  endian: le

doc: |
  :field name: ax25_frame.ax25_header.dest_callsign_raw.callsign_ror.callsign

  Attention: `rpt_callsign` cannot be accessed because `rpt_instance` is an
  array of unknown size at the beginning of the parsing process! Left an
  example in here.

seq:
  - id: ax25_frame
    type: ax25_frame
    doc-ref: 'https://www.tapr.org/pub_ax25.html'

types:
  ax25_frame:
    seq:
      - id: ax25_header
        type: ax25_header
      - id: payload
        type:
          switch-on: ax25_header.ctl & 0x13
          cases:
            0x03: ui_frame
            0x13: ui_frame
            0x00: i_frame
            0x02: i_frame
            0x10: i_frame
            0x12: i_frame
            # 0x11: s_frame

  ax25_header:
    seq:
      - id: dest_callsign_raw
        type: callsign_raw
      - id: dest_ssid_raw
        type: ssid_mask
      - id: src_callsign_raw
        type: callsign_raw
      - id: src_ssid_raw
        type: ssid_mask
      - id: repeater
        type: repeater
        if: (src_ssid_raw.ssid_mask & 0x01) == 0
        doc: 'Repeater flag is set!'
      - id: ctl
        type: u1

  repeater:
    seq:
      - id: rpt_instance
        type: repeaters
        repeat: until
        repeat-until: ((_.rpt_ssid_raw.ssid_mask & 0x1) == 0x1)
        doc: 'Repeat until no repeater flag is set!'

  repeaters:
    seq:
      - id: rpt_callsign_raw
        type: callsign_raw
      - id: rpt_ssid_raw
        type: ssid_mask

  callsign_raw:
    seq:
      - id: callsign_ror
        process: ror(1)
        size: 6
        type: callsign

  callsign:
    seq:
      - id: callsign
        type: str
        encoding: ASCII
        size: 6

  ssid_mask:
    seq:
      - id: ssid_mask
        type: u1
    instances:
      ssid:
        value: (ssid_mask & 0x0f) >> 1

  i_frame:
    seq:
      - id: pid
        type: u1
      - id: ax25_info
        type: ax25_info_data
        size-eos: true

  ui_frame:
    seq:
      - id: pid
        type: u1
      - id: ax25_info
        type: ax25_info_data
        size-eos: true

  ax25_info_data:
    seq:
      - doc: '"{{z" User-Defined APRS packet format'
        id: aprs_packet_data_type_identifier
        type: u1
      - doc: CURRENT = 0
        id: aprs_packet_revision
        type: u1
      - doc: Character representing C3 critical state
        id: c3_m4_oresat0_state
        type: b1
      - doc: Stick at 0xFFFFFF if we reach 194 days of uptime :)
        id: c3_m4_uptime
        type: u4
      - id: c3_rtc_time
        type: u4
      - id: c3_m4_temperature
        type: s1
      - id: c3_m4_ref_voltage
        type: u1
      - id: c3_m4_vbusp_voltage
        type: u1
      - doc: '"VBUS_ILIM" from U4 (TS59621 with 3.1k resistor)'
        id: c3_m4_vbusp_current
        type: u1
      - doc: Stored in FRAM; Stick at 0xFFFF until reset from ground
        id: c3_wdt_num_timeouts
        type: u2
      - id: c3_emmc_perc_full
        type: u1
      - id: c3_l_rx_bytes_received
        type: u4
      - id: c3_l_rx_valid_packets
        type: u4
      - doc: Of last packet received; -126 to -45 dBm range; 1 dB step; after LNA, filters,
          and digital channel filter.
        id: c3_l_rx_rssi
        type: u1
      - doc: '0 : AX5043 PLL Lock; 1 : Downconverter synth PLL lock; More space in bit field
          available'
        id: c3_l_rx_pll_lock
        type: b1
      - id: c3_uhf_tx_temperature
        type: s1
      - doc: '"UHF_LOG_RF_FWD" from U32; Scaled to usable dBm range'
        id: c3_uhf_tx_fwd_forward_power
        type: u2
      - doc: '"UHF_LOG_RF_REV" from U33; Scaled to usable dBm range'
        id: c3_uhf_tx_rev_reverse_power
        type: u2
      - id: c3_uhf_rx_bytes_received
        type: u4
      - id: c3_uhf_rx_valid_packets
        type: u4
      - doc: Of last packet received; -126 to -45 dBm range; 1 dB step; after LNA, filters,
          and digital channel filter.
        id: c3_uhf_rx_rssi
        type: u1
      - doc: '0 : AX5043 PLL Lock; More space in bit field available'
        id: c3_uhf_rx_pll_lock
        type: b1
      - id: c3_deployer_1_read_back
        type: b1
      - doc: 'Operational/High # errors/Other CAN status? '
        id: c3_can1_state
        type: b1
      - doc: 'Operational/High # errors/Other CAN status? '
        id: c3_can2_state
        type: b1
      - doc: '"OPD_ILIM" from U? (MAX? with ?k resistor)'
        id: c3_opd_current
        type: u1
      - doc: Which OPDs are currently on
        id: c3_opd_state
        type: u1
      - id: battery_pack_1_vbatt
        type: u2
      - id: battery_pack_1_vcell
        type: u2
      - id: battery_pack_1_vcell_max
        type: u2
      - id: battery_pack_1_vcell_min
        type: u2
      - id: battery_pack_1_vcell_1
        type: u2
      - id: battery_pack_1_vcell_2
        type: u2
      - id: battery_pack_1_vcell_avg
        type: u2
      - id: battery_pack_1_temperature
        type: s2
      - id: battery_pack_1_temperature_avg
        type: s2
      - id: battery_pack_1_temperature_max
        type: s2
      - id: battery_pack_1_temperature_min
        type: s2
      - id: battery_pack_1_current
        type: s2
      - id: battery_pack_1_current_avg
        type: s2
      - id: battery_pack_1_current_max
        type: s2
      - id: battery_pack_1_current_min
        type: s2
      - id: battery_pack_1_state
        type: u1
      - id: battery_pack_1_reported_state_of_charge
        type: u1
      - id: battery_pack_1_full_capacity
        type: u2
      - id: battery_pack_1_reported_capacity
        type: u2
      - id: battery_pack_2_vbatt
        type: u2
      - id: battery_pack_2_vcell
        type: u2
      - id: battery_pack_2_vcell_max
        type: u2
      - id: battery_pack_2_vcell_min
        type: u2
      - id: battery_pack_2_vcell_1
        type: u2
      - id: battery_pack_2_vcell_2
        type: u2
      - id: battery_pack_2_vcell_avg
        type: u2
      - id: battery_pack_2_temperature
        type: s2
      - id: battery_pack_2_temperature_avg
        type: s2
      - id: battery_pack_2_temperature_max
        type: s2
      - id: battery_pack_2_temperature_min
        type: s2
      - id: battery_pack_2_current
        type: s2
      - id: battery_pack_2_current_avg
        type: s2
      - id: battery_pack_2_current_max
        type: s2
      - id: battery_pack_2_current_min
        type: s2
      - id: battery_pack_2_state
        type: u1
      - id: battery_pack_2_reported_state_of_changed
        type: u1
      - id: battery_pack_2_full_capacity
        type: u2
      - id: battery_pack_2_reported_capacity
        type: u2
      - id: solar_minus_x_voltage_avg
        type: u2
      - id: solar_minus_x_current_avg
        type: s2
      - id: solar_minus_x_power_avg
        type: u2
      - id: solar_minus_x_voltage_max
        type: u2
      - id: solar_minus_x_current_max
        type: s2
      - id: solar_minus_x_power_max
        type: u2
      - id: solar_minus_x_energy
        type: u2
      - id: solar_minus_y_voltage_avg
        type: u2
      - id: solar_minus_y_current_avg
        type: s2
      - id: solar_minus_y_power_avg
        type: u2
      - id: solar_minus_y_voltage_max
        type: u2
      - id: solar_minus_y_current_max
        type: s2
      - id: solar_minus_y_power_max
        type: u2
      - id: solar_minus_y_energy
        type: u2
      - id: solar_plus_x_voltage_avg
        type: u2
      - id: solar_plus_x_current_avg
        type: s2
      - id: solar_plus_x_power_avg
        type: u2
      - id: solar_plus_x_voltage_max
        type: u2
      - id: solar_plus_x_current_max
        type: s2
      - id: solar_plus_x_power_max
        type: u2
      - id: solar_plus_x_energy
        type: u2
      - id: solar_plus_y_voltage_avg
        type: u2
      - id: solar_plus_y_current_avg
        type: s2
      - id: solar_plus_y_power_avg
        type: u2
      - id: solar_plus_y_voltage_max
        type: u2
      - id: solar_plus_y_current_max
        type: s2
      - id: solar_plus_y_power_max
        type: u2
      - id: solar_plus_y_energy
        type: u2
      - id: star_tracker_emmc_capacity
        type: u1
      - id: star_tracker_readable_files
        type: u1
      - id: star_tracker_updater_status
        type: u1
      - id: star_tracker_updates_cached
        type: u1
      - id: star_tracker_right_ascension
        type: s2
      - id: star_tracker_declination
        type: s2
      - id: star_tracker_roll
        type: s2
      - id: star_tracker_timestamp_of_last_packet
        type: u4
      - id: gps_emmc_capacity
        type: u1
      - id: gps_readable_files
        type: u1
      - id: gps_updater_status
        type: u1
      - id: gps_updates_cached
        type: u1
      - id: gps_gps_status
        type: u1
      - id: gps_num_of_sats_locked
        type: u1
      - id: gps_x_position
        type: s4
      - id: gps_y_postition
        type: s4
      - id: gps_z_position
        type: s4
      - id: gps_x_velocity
        type: s4
      - id: gps_y_velocity
        type: s4
      - id: gps_z_velocity
        type: s4
      - id: gps_timestamp_of_last_packet
        type: u4
      - id: ads_gyro_roll_dot
        type: s2
      - id: ads_gyro_pitch_dot
        type: s2
      - id: ads_gyro_yaw_dot
        type: s2
      - id: ads_gyro_imu_temp
        type: s1
      - id: dxwifi_emmc_capacity
        type: u1
      - id: dxwifi_readable_files
        type: u1
      - id: dxwifi_updater_status
        type: u1
      - id: dxwifi_updates_cached
        type: u1
      - id: dxwifi_transmitting
        type: b1
      - doc: Polynomial 0x04C11DB7; computed over all bytes allocated
        id: aprs_packet_crc_minus_32
        type: u4
