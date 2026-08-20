/*
 * Copyright (c) 2026 ID8 Engineering AB
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <string.h>

#include <modem/nrf_modem_lib.h>
#include <nrf_modem_at.h>
#include <zephyr/device.h>
#include <zephyr/drivers/led_strip.h>
#include <zephyr/drivers/pwm.h>
#include <zephyr/kernel.h>
#include <zephyr/ztest.h>

#define AT_RESPONSE_SIZE 64
#define BUZZER_PERIOD PWM_HZ(2000)
#define EXPECTED_MODEM_FIRMWARE "mfw_nrf91x1_2.0.4"

static const struct device *led_strip =
    DEVICE_DT_GET(DT_CHOSEN(zephyr_led_strip));
static const struct pwm_dt_spec buzzer =
    PWM_DT_SPEC_GET(DT_NODELABEL(buzzer));

ZTEST(modem, test_firmware_version) {
  int err;
  size_t version_length;
  char response[AT_RESPONSE_SIZE];

  err = nrf_modem_lib_init();
  zassert_ok(err, "Modem initialization failed: %d", err);

  err = nrf_modem_at_cmd(response, sizeof(response), "AT+CGMR");
  zassert_ok(err, "AT+CGMR failed: %d", err);

  version_length = strcspn(response, "\r\n");
  response[version_length] = '\0';

  TC_PRINT("Modem firmware: %s\n", response);
  zassert_equal(0, strcmp(response, EXPECTED_MODEM_FIRMWARE),
                "Expected %s, got %s", EXPECTED_MODEM_FIRMWARE, response);

  (void)nrf_modem_lib_shutdown();
}

ZTEST(peripherals, test_rgb_led) {
  int err;

  struct led_rgb pixel_on = {
      .r = 0x00,
      .g = 0xFF,
      .b = 0x00,
  };

  struct led_rgb pixel_off = {
      .r = 0x00,
      .g = 0x00,
      .b = 0x00,
  };

  zassert_true(device_is_ready(led_strip), "RGB LED device is not ready");

  for (int i = 0; i < 3; i++) {
    err = led_strip_update_rgb(led_strip, &pixel_on, 1);
    zassert_ok(err, "Failed to turn on RGB LED");

    k_msleep(100);

    err = led_strip_update_rgb(led_strip, &pixel_off, 1);
    zassert_ok(err, "Failed to turn off RGB LED");

    k_msleep(100);
  }
}

ZTEST(peripherals, test_buzzer) {
  int err;

  zassert_true(pwm_is_ready_dt(&buzzer), "Buzzer PWM device is not ready");

  for (int i = 0; i < 3; i++) {
    err = pwm_set_dt(&buzzer, BUZZER_PERIOD, BUZZER_PERIOD / 2);
    zassert_ok(err, "Failed to turn on buzzer");

    k_msleep(100);

    err = pwm_set_dt(&buzzer, BUZZER_PERIOD, 0);
    zassert_ok(err, "Failed to turn off buzzer");

    k_msleep(100);
  }
}

ZTEST_SUITE(modem, NULL, NULL, NULL, NULL, NULL);
ZTEST_SUITE(peripherals, NULL, NULL, NULL, NULL, NULL);
