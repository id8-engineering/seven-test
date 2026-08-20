/*
 * Copyright (c) 2026 ID8 Engineering AB
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <string.h>

#include <modem/nrf_modem_lib.h>
#include <nrf_modem_at.h>
#include <zephyr/ztest.h>

#define AT_RESPONSE_SIZE 64
#define EXPECTED_MODEM_FIRMWARE "mfw_nrf91x1_2.0.4"

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

ZTEST_SUITE(modem, NULL, NULL, NULL, NULL, NULL);
