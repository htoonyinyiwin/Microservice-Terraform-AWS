"use strict";

/**
 * @typedef {import('moleculer').ServiceSchema} ServiceSchema Moleculer's Service Schema
 * @typedef {import('moleculer').Context} Context Moleculer's Context
 */

/** @type {ServiceSchema} */
module.exports = {
        name: "greeter",

        /**
         * Settings
         */     settings: {

        },

        /**
         * Dependencies
         */
        dependencies: [],

        /**
         * Actions
         */
        actions: {

                /**
                 * Say a 'Hello' action.
                 *
                 * @returns
                 */
                // hello: {
                //      rest: {
                //              method: "GET",
                //              path: "/hello"
                //      },
                //      async handler() {
                //              return "Hello Moleculer";
                //      }
                // },

                async hello(ctx) {
                  const service1 = 'Hello from service1@${this.broker.nodeID}';

                        const service2 = await ctx.call("helper.random");

                  ctx.emit("hello.called", {service1, service2 });

                  return { service1, service2 };
                },

                /**
                 * Welcome, a username
                 *
                 * @param {String} name - User name
                 */
                welcome: {
                        rest: "/welcome",
                        params: {
                                name: "string"
                        },
                        /** @param {Context} ctx  */
                        async handler(ctx) {
                                return `Welcome, ${ctx.params.name}`;
                        }
                }
        },

        /**
         * Events
         */
        events: {

        },

        /**
         * Methods
         */
        methods: {

        },

        /**
         * Service created lifecycle event handler
         */
        created() {

        },

        /**
         * Service started lifecycle event handler
         */
        async started() {

        },

        /**
         * Service stopped lifecycle event handler
         */
        async stopped() {

        }
};