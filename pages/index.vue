<template>
  <div class="container">
    <CBox
      v-bind="mainStyles[colorMode]"
      d="flex"
      w="100vw"
      h="100vh"
      flex-dir="column"
      justify-content="center"
    >

      <CFlex justify-content="center" direction="column" align="center" flex="1">
        <CBox mb="3">
          <CInput placeholder="URL for short" id="originalLink"/>
        </CBox>
        <CCollapse mb="3" :is-open="isLinkLoaded">
          <CTag variant-color="blue">
            <CLink href="#" isExternal id="loadedLink">
              loadedlink
            </CLink>
          </CTag>
        </CCollapse>
        <CButton
          :is-loading="isLoadingLink"
          variant="outline"
          color="white"
          mt="3"
          @click="getShortLink"
        >
          Get short
        </CButton>
      </CFlex>

      <CFlex direction="column" align="center" flex-shrink="0">
        <CBox mb="3">
          <CTag rounded="full" variant-color="red">Powder by&nbsp; <u><a href="https://github.com/Egnod/tyazhko">Tyazhko</a></u>&nbsp;💖</CTag>
        </CBox>
      </CFlex>
    </CBox>
  </div>
</template>

<script lang="js">
import {
  CBox,
  CButton,
  CAvatarGroup,
  CAvatar,
  CAvatarBadge,
  CModal,
  CModalContent,
  CModalOverlay,
  CModalHeader,
  CModalFooter,
  CModalBody,
  CModalCloseButton,
  CIconButton,
  CFlex,
  CHeading,
  CInput,
  CTag,
  CCollapse,
  CLink,
  CIcon
} from '@chakra-ui/vue'

import axios from '~/plugins/axios';

export default {
  name: 'App',
  inject: ['$chakraColorMode', '$toggleColorMode'],
  components: {
    CBox,
    CButton,
    CAvatarGroup,
    CAvatar,
    CAvatarBadge,
    CModal,
    CModalContent,
    CModalOverlay,
    CModalHeader,
    CModalFooter,
    CModalBody,
    CModalCloseButton,
    CIconButton,
    CFlex,
    CHeading,
    CInput,
    CTag,
    CCollapse,
    CLink,
    CIcon
  },
  data () {
    return {
      isLoadingLink: false,
      isLinkLoaded: false,
      mainStyles: {
        dark: {
          backgroundColor: 'blackAlpha.900',
          color: 'blackAlpha.800'
        }
      }
    }
  },
  computed: {
    colorMode () {
      return 'dark'
    }
  },
  methods: {
    getShortLink() {
      this.isLoadingLink = true

      const originalLink = document.getElementById("originalLink");
      const urlregex = /^(https?|ftp):\/\/([a-zA-Z0-9.-]+(:[a-zA-Z0-9.&%$-]+)*@)*((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3}|([a-zA-Z0-9-]+\.)*[a-zA-Z0-9-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(:[0-9]+)*(\/($|[a-zA-Z0-9.,?'\\+&%$#=~_-]+))*$/;

      const isValidUrl = urlregex.test(originalLink.value);

      if (!isValidUrl){
        this.$toast({
          title: "URL is invalid",
          description: "Inputed url is invalid!",
          status: "error",
          duration: 3000,
          isClosable: true,
        })
        this.isLoadingLink = false
        return
      }

      axios.post(`/`, {
        origin_link: originalLink.value
      }).catch((error) => {
        this.$toast({
          title: "Invalid server response",
          description: "Code: " + error.response.status +"\nBody: " + error.response.statusText,
          status: "error",
          duration: 3000,
          isClosable: true,
        })

        this.isLoadingLink = false
      }).then((response) => {
        document.getElementById("loadedLink").href = `${axios.defaults.baseURL}/${response.data.short_id}`
        document.getElementById("loadedLink").innerText = `${axios.defaults.baseURL}/${response.data.short_id}`

        const inp = document.createElement('input');
        document.body.appendChild(inp)

        inp.value = `${axios.defaults.baseURL}/${response.data.short_id}`

        inp.select();
        document.execCommand('copy',false);
        inp.remove();

        this.$toast({
          title: "Shorted!",
          description: "Your short link copy to buffer!",
          status: "success",
          duration: 3000,
          isClosable: true,
        })

        this.isLoadingLink = false
        this.isLinkLoaded = true
      })
    }
  }
}
</script>
